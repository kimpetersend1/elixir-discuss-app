defmodule DiscussWeb.TopicController do
  use DiscussWeb, :controller

  # using an alias changes %Discuss.Topic{} to %Topic{}
  alias Discuss.Topic
  alias Discuss.Repo
  alias DiscussWeb.Router.Helpers

  def index(conn, _params) do
    topics = Repo.all(Topic)
    render conn, "index.html", topics: topics
  end

  # conn === connection (incoming/outgoing request) i.e. think about Django request object
  def new(conn, _params) do
    changeset = Topic.changeset(%Topic{}, %{})

    # passing changeset, into the template, to be used as: @changeset
    # conn arg is automatically passed in
    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"topic" => topic}) do
    # %{"topic" => topic}) comes from pattern matching against params
    # create a new changeset from the topic params getting passed in from the form
    # changeset represents a new record we want to insert into the DB
    # because we inserting a new value we have a empty struct

    changeset = Topic.changeset(%Topic{}, topic)
    case Repo.insert(changeset) do
      {:ok, _topic} ->
        conn
        |> put_flash(:info, "Topic Created") # popup message in the UI
        |> redirect(to: Helpers.topic_path(conn, :index)) # redirect to the index page
      {:error, changeset} ->
        render conn, "new.html", changeset: changeset
    end
  end

  def edit(conn, %{"id" => topic_id}) do
    # %{"id" => topic_id} comes from pattern matching against params
    # Get a single Topic out the db that matches the id topic_id
    # Repo.get takes 2 args, the type we wanna fetch out the db & the id of the record we wanna fetch
    # we make a changeset as the form helpers expect to be working with a changeset

    topic = Repo.get(Topic, topic_id)
    changeset = Topic.changeset(topic)

    render conn, "edit.html", changeset: changeset, topic: topic
  end

  def update(conn, %{"id" => topic_id, "topic" => topic}) do
    # Repo.get(Topic, topic_id) => this returns a struct that gets pass as the first arg into changeset

     old_topic = Repo.get(Topic, topic_id)
     changeset = Topic.changeset(old_topic, topic)

    case Repo.update(changeset) do
      {:ok, _topic} ->
        conn
        |> put_flash(:info, "Topic updated")
        |> redirect(to: Helpers.topic_path(conn, :index))
      {:error, changeset} ->
        render conn, "edit.html", changeset: changeset, topic: old_topic
    end
  end

  def delete(conn, %{"id" => topic_id}) do
    Repo.get!(Topic, topic_id) |> Repo.delete!

    conn
    |> put_flash(:info, "Topic Deleted")
    |> redirect(to: Helpers.topic_path(conn, :index))
  end
end
