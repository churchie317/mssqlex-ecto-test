defmodule Ectotest do

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      supervisor(EctoTest.Repo, [])
    ]
  end

end
