defmodule WabanexWeb.IMCControllerTest do
  use WabanexWeb.ConnCase, async: true

  describe "index/2" do

    test "when all params are valid, returns the imc info", %{conn: conn} do
      params = %{"filename" => "students.csv"}

      response =
        conn
        |> get(Routes.imc_path(conn, :index, params))
        |> json_response(:ok)

      expected_response = %{
        "result" => %{
          "Henrique" => 20.61855670103093,
          "Julia" => 16.666666666666668,
          "Lorena" => 15.406976744186046,
          "Maria" => 15.064102564102564,
          "Vinicius" => 18.529411764705884
        }
      }

      assert response == expected_response
    end

    test "when there are invalid params, return an error", %{conn: conn} do
      params = %{"filename" => "invalid.csv"}

      response =
        conn
        |> get(Routes.imc_path(conn, :index, params))
        |> json_response(:bad_request)

      expected_response = %{"result" => "Error while opening the file"}

      assert response == expected_response
    end

  end
end
