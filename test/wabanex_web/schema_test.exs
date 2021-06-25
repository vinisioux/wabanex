defmodule WabanexWeb.SchemaTest do
  use WabanexWeb.ConnCase, async: true

  alias Wabanex.User
  alias Wabanex.Users.Create

  describe "users queries" do

    test "when a valid id is given, returns the user", %{conn: conn} do
      params = %{email: "test@test.com", name: "Name Test", password: "123456"}

      {:ok, %User{id: user_id}} = Create.call(params)

      query = """
        {
          getUser(id: "#{user_id}") {
            email
            name
            id
          }
        }
      """

      response =
        conn
        |> post("api/graphql", %{query: query})
        |> json_response(:ok)

      expected_response =  %{
        "data" => %{
          "getUser" => %{
            "email" => "test@test.com",
            "id" => "#{user_id}",
            "name" => "Name Test"
          }
        }
      }

      assert response == expected_response
    end

    test "when a wrong id is given, returns an error", %{conn: conn} do
      query = """
        {
          getUser(id: "e38cb348-afb2-4b0e-b52a-6b11b82cef5f") {
            email
            name
            id
          }
        }
      """

      response =
        conn
        |> post("api/graphql", %{query: query})
        |> json_response(:ok)

      expected_response =  %{
        "data" => %{"getUser" => nil},
        "errors" => [%{"locations" => [%{"column" => 5, "line" => 2}], "message" => "User not found", "path" => ["getUser"]}]
      }

      assert response == expected_response
    end

    test "when an invalid id is given, returns an error", %{conn: conn} do
      query = """
        {
          getUser(id: "wrong uuid") {
            email
            name
            id
          }
        }
      """

      response =
        conn
        |> post("api/graphql", %{query: query})
        |> json_response(:ok)

      expected_response =  %{
        "errors" => [
          %{
            "locations" => [%{"column" => 13, "line" => 2}],
            "message" => "Argument \"id\" has invalid value \"wrong uuid\"."
          }
        ]
      }

      assert response == expected_response
    end
  end

  describe "users mutations" do

    test "when all params are valid, creates the user", %{conn: conn} do
      mutation = """
        mutation {
          createUser(input: {
              email: "test@test.com",
              name: "Name Test",
              password: "123456"
            }
          ) {
            id
            email
            name
          }
        }
      """

      response =
        conn
        |> post("api/graphql", %{query: mutation})
        |> json_response(:ok)

      assert %{"data" => %{"createUser" => %{"id" => _id, "email" => "test@test.com", "name" => "Name Test"}}} = response
    end

  end
end
