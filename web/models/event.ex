defmodule MeetingStories.Event do
  use MeetingStories.Web, :model

  schema "events" do
    belongs_to :calendar, ChargingIo.Calendar

    field :origin_id, :string
    field :summary, :string
    field :status, :string
    field :origin_created_at, Timex.Ecto.DateTime
    field :origin_updated_at, Timex.Ecto.DateTime
    field :starts_at, Timex.Ecto.DateTime
    field :ends_at, Timex.Ecto.DateTime

    timestamps
  end

  @required_fields ~w(calendar_id origin_id summary status)
  @optional_fields ~w(origin_created_at origin_updated_at starts_at ends_at)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
