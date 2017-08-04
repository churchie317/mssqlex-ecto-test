defmodule Ectotest do
  use Application

  def start(_type, _args) do
    EctoTest.Supervisor.start_link(:ok)
  end

end
