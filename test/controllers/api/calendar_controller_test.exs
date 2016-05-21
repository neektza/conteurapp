defmodule ConteurApp.Api.CalendarControllerTest do
  use ConteurApp.ConnCase

  alias ConteurApp.Api.Calendar
  @valid_attrs %{}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, calendar_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    calendar = Repo.insert! %Calendar{}
    conn = get conn, calendar_path(conn, :show, calendar)
    assert json_response(conn, 200)["data"] == %{"id" => calendar.id}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, calendar_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, calendar_path(conn, :create), calendar: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Calendar, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, calendar_path(conn, :create), calendar: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    calendar = Repo.insert! %Calendar{}
    conn = put conn, calendar_path(conn, :update, calendar), calendar: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Calendar, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    calendar = Repo.insert! %Calendar{}
    conn = put conn, calendar_path(conn, :update, calendar), calendar: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    calendar = Repo.insert! %Calendar{}
    conn = delete conn, calendar_path(conn, :delete, calendar)
    assert response(conn, 204)
    refute Repo.get(Calendar, calendar.id)
  end
end