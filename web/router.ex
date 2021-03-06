defmodule ConteurApp.Router do
  use ConteurApp.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :fetch_session
    plug :accepts, ["json"]
    plug CORSPlug
  end

  scope "/", ConteurApp do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :landing
    get "/app", PageController, :app
  end

  scope "/api", ConteurApp.Api do
    pipe_through :api

    resources "/calendars", CalendarController, only: [:index, :show]
    resources "/events", EventController, only: [:index, :show]
    resources "/stories", StoryController, only: [:index, :show]

    get "/postback/events", PostbackController, :hi
    post "/postback/events", PostbackController, :handle_event
    get "/postback/calendars", PostbackController, :hi
    post "/postback/calendars", PostbackController, :handle_calendar
  end

  scope "/auth", ConteurApp do
    pipe_through :browser

    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
    post "/:provider/callback", AuthController, :callback
    delete "/logout", AuthController, :delete
  end

  # FOR DEBUGGING 
  scope "/sync", ConteurApp do
    pipe_through :browser

    get "/calendars", SyncController, :calendars
    post "/calendars", SyncController, :calendars
    get "/calendars/:calendar_id", SyncController, :calendar_events
    post "/calendars/:calendar_id", SyncController, :calendar_events
  end
end
