defmodule MeetingStories.CalendarController do
  use MeetingStories.Web, :controller
  alias MeetingStories.Calendar
  alias MeetingStories.Event
  import Ecto.Query

  plug :put_layout, "dashboard.html"
  plug MeetingStories.Plug.Authenticate
  plug :scrub_params, "calendar" when action in [:create, :update]

  def index(conn, _params) do
    calendars = Repo.all(Calendar)
    render(conn, "index.html", calendars: calendars)
  end

  def show(conn, %{"id" => id}) do
    current_user = conn.assigns.current_user

    calendar = Repo.get!(Calendar, id)

    events_query =
      Event
      |> join(:inner, [e], c in assoc(e, :calendar))
      |> join(:inner, [e, c], u in assoc(c, :user))
      |> where([e, c, u], u.id == ^current_user.id)
      |> preload([e, c, u], [:calendar])
      |> conditional_calendar_filter(id)

    events = Repo.all(events_query)

    render(conn, "show.html", calendar: calendar, events: events)
  end
  
  defp conditional_calendar_filter(query, cal_id) do
    if cal_id do
      query |> where([e, c, u], e.calendar_id == ^cal_id)
    else
      query
    end
  end
end
