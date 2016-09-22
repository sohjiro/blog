---
title: "Ecto Transactions"
date: "2016-09-20T19:35:08-05:00"
author: Felipe Juarez
comments: true
tags: [elixir, ecto]
---

It has been a couple of months since I wrote something and was about `phoenix` and `bootstrap`. Today I'm going to talk about `elixir`, `ecto` and how to manage `transactions`

Well in this post we are going to skip `ecto setup` (if for some way, it was need it, please leave a comment and I will make a post for it, but I think his [documentation](https://github.com/elixir-ecto/ecto) makes a fairly good example for it)

With that in mind, these are the tables that we are going to use.

* Project table
{{< highlight elixir >}}
defmodule EctoTransactions.Project do
  use Ecto.Schema
  import Ecto.Changeset

  schema "projects" do
    field :name
    has_many :tasks, EctoTransactions.Task

    timestamps
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name])
    |> validate_required([:name])
  end

end
{{< /highlight >}}

* Task table
{{< highlight elixir >}}
defmodule EctoTransactions.Task do
  use Ecto.Schema

  import Ecto.Changeset

  schema "tasks" do
    field :description
    belongs_to :project, EctoTransactions.Project

    timestamps
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:description, :project_id])
    |> validate_required([:description, :project_id])
  end
end
{{< /highlight >}}

With both tables we can see that `Task` depends from `Project`. So we are going to create a `project` with a `task` and we are going to see how can we handle a creation like that.

The first thing we should know is, how can we create a transaction? With this instruction `Repo.transaction(fn -> end)` Between `arrow` and `end` we put the code that we need. And for making a `rollback` we use `Repo.rollback(value)` and between parenthesis we can indicate the reason of why we are making that decision.

So we are going to create a module for handling this

{{< highlight elixir >}}
  defmodule EctoTransactions.App do

    import Ecto
    alias EctoTransactions.Repo
    alias EctoTransactions.Project
    alias EctoTransactions.Task

    # creating project and task
    def create_project_with_task(project_params, task_params) do
      Repo.transaction(fn ->
        project_params
        |> create_project_with_params
        |> add_task_to_project(task_params)
      end)
    end

    # creating project
    defp create_project_with_params(project_params) do
      %Project{}
      |> Project.changeset(project_params)
      |> Repo.insert
    end

    # adding a task to a valid project
    defp add_task_to_project({:ok, project}, task_params) do
      changeset = project
                  |> build_assoc(:tasks)
                  |> Task.changeset(task_params)

      case Repo.insert(changeset) do
        {:ok, _task} -> project
        {:error, changeset} -> Repo.rollback(:task) # Rollback transaction for invalid task data
      end
    end
    defp add_task_to_project({:error, _changeset}, _task_params),
    do: Repo.rollback(:project) # Rollback transaction for invalid project data

  end
{{< /highlight >}}

So if we use `iex -S mix` and passing some args to this we can obtain the following results

* Passing good options
{{< highlight elixir >}}
iex(1)> project_params = %{name: "Explain ecto transactions"}
%{name: "Explain ecto transactions"}
iex(2)> task_params = %{description: "Should create task for example"}
%{description: "Should create task for example"}
iex(3)> EctoTransactions.App.create_project_with_task(project_params, task_params)

22:28:59.905 [debug] QUERY OK db=0.2ms queue=0.1ms
begin []

22:28:59.917 [debug] QUERY OK db=0.9ms
INSERT INTO "projects" ("name","inserted_at","updated_at") VALUES ($1,$2,$3) RETURNING "id" ["Explain ecto transactions", {{2016, 9, 21}, {3, 28, 59, 0}}, {{2016, 9, 21}, {3, 28, 59, 0}}]

22:28:59.921 [debug] QUERY OK db=3.1ms
INSERT INTO "tasks" ("description","project_id","inserted_at","updated_at") VALUES ($1,$2,$3,$4) RETURNING "id" ["Should create task for example", 1, {{2016, 9, 21}, {3, 28, 59, 0}}, {{2016, 9, 21}, {3, 28, 59, 0}}]

22:28:59.922 [debug] QUERY OK db=0.3ms
commit []
{:ok,
 %EctoTransactions.Project{__meta__: #Ecto.Schema.Metadata<:loaded, "projects">,
  id: 1, inserted_at: #Ecto.DateTime<2016-09-21 03:28:59>,
  name: "Explain ecto transactions",
  tasks: #Ecto.Association.NotLoaded<association :tasks is not loaded>,
  updated_at: #Ecto.DateTime<2016-09-21 03:28:59>}}
{{< /highlight >}}

{{< highlight psql >}}
ecto_simple> select * from projects; select * from tasks;
+------+---------------------------+---------------------+---------------------+
|   id | name                      | inserted_at         | updated_at          |
|------+---------------------------+---------------------+---------------------|
|    1 | Explain ecto transactions | 2016-09-21 03:28:59 | 2016-09-21 03:28:59 |
+------+---------------------------+---------------------+---------------------+
SELECT 1
+------+--------------------------------+--------------+---------------------+---------------------+
|   id | description                    |   project_id | inserted_at         | updated_at          |
|------+--------------------------------+--------------+---------------------+---------------------|
|    1 | Should create task for example |            1 | 2016-09-21 03:28:59 | 2016-09-21 03:28:59 |
+------+--------------------------------+--------------+---------------------+---------------------+
SELECT 1
Time: 0.003s
{{< /highlight >}}

And for bad data we can obtain next results:

{{< highlight elixir >}}
iex(4)> project_params = %{name: 1}
%{name: 1}
iex(5)> task_params = %{description: nil}
%{description: nil}
iex(6)> EctoTransactions.App.create_project_with_task(project_params, task_params)

22:49:25.863 [debug] QUERY OK db=0.2ms
begin []

22:49:25.865 [debug] QUERY OK db=0.2ms
rollback []
{:error, :project}

iex(7)> project_params = %{name: "Explain ecto transactions"}
%{name: "Explain ecto transactions"}
iex(8)> EctoTransactions.App.create_project_with_task(project_params, task_params)

22:49:53.345 [debug] QUERY OK db=0.3ms queue=0.1ms
begin []

22:49:53.346 [debug] QUERY OK db=1.2ms
INSERT INTO "projects" ("name","inserted_at","updated_at") VALUES ($1,$2,$3) RETURNING "id" ["Explain ecto transactions", {{2016, 9, 21}, {3, 49, 53, 0}}, {{2016, 9, 21}, {3, 49, 53, 0}}]
#Ecto.Changeset<action: :insert, changes: %{},
 errors: [description: {"can't be blank", []}], data: #EctoTransactions.Task<>,
 valid?: false>

22:49:53.348 [debug] QUERY OK db=0.2ms
rollback []
{:error, :task}
iex(9)>
{{< /highlight >}}

If you read with attention you will see two tupples `{:error, :project}` and `{:error, :task}` with this you can make the assumptions that you want, of course you could say a lot more and instead of returning tupples you return other things with more sense for example change `:project` or `:task` for his respective `changeset` and you should see other things.

By the way when use `Repo.transaction` you should return the implicit data (that is the schema you are saving) that's because `Repo.transaction` return a tupple consisting of an `:ok` atom and the respective last instruction. And if you use `Repo.insert` as returning data you will see a tupple of tupple `{:ok, {:ok, data}}` or `{:ok, {:error, data}}` (thats because the return of an insert is `{:ok, data}` or `{:error, data}`) and that's why we use `Repo.rollback` for forcing a tupple consisting of `{:error, reason}`

That's all folks! I hope this can help you. And remember Good Luck, Have Fun! and GG!
