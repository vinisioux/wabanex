defmodule Wabanex.UserTest do
  use Wabanex.DataCase, async: true

  alias Wabanex.User

  describe "changeset/1" do

    test "when all params are valid returns a valid changeset" do
      params = %{name: "Name Test", email: "test@test.com", password: "123456"}

      response = User.changeset(params)

      assert %Ecto.Changeset{
        valid?: true,
        changes: %{email: "test@test.com", name: "Name Test", password: "123456"},
        errors: []
      } = response
    end

    test "when there are invalid params returns an invalid changeset" do
      params = %{name: "N", email: "testtest.com", password: "12345"}

      response = User.changeset(params)

      expected_response =  %{
        email: ["has invalid format"],
        name: ["should be at least 2 character(s)"],
        password: ["should be at least 6 character(s)"]
      }

      assert errors_on(response) == expected_response
    end

  end
end
