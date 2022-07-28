defmodule Discuss.Topic do
  use Ecto.Schema
  import Ecto.Changeset

  schema "topics" do
    field :title, :string
  end

  def changeset(struct, params \\ %{}) do
    # Struct: A hash that contains some data. Represents a record in the database
    # Params: A hash that contains the properties we want to update on the struct
    # Cast: Produces a changeset
    # Validators: Adds errors to changesets
    # Changeset: Knows the data we are trying to save and whether or not there are validation issues with it
    struct
    |> cast(params, [:title])
    |> validate_required([:title])
  end
end
