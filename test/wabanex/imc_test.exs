defmodule Wabanex.IMCTest do
  use ExUnit.Case, async: true

  alias Wabanex.IMC

  describe "calculate/1" do
    test "when the file exists, returns the data" do
      params = %{"filename" => "students.csv"}

      response = IMC.calculate(params)

      expected_response =
        {:ok,
          %{
            "Henrique" => 20.61855670103093,
            "Julia" => 16.666666666666668,
            "Lorena" => 15.406976744186046,
            "Maria" => 15.064102564102564,
            "Vinicius" => 18.529411764705884
          }
        }

      assert response == expected_response
    end

    test "when a wrong filename is given, returns an error" do
      params = %{"filename" => "wrongfile.csv"}

      response = IMC.calculate(params)

      expected_response = {:error, "Error while opening the file"}

      assert response == expected_response
    end
  end
end
