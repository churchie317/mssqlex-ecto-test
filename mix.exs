defmodule Ectotest.Mixfile do
  use Mix.Project

  def project do
    [app: :ectotest,
     version: "0.1.0",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     escript: [ main_module: EctoTest.CLI ],
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    # Specify extra applications you'll use from Erlang/Elixir
    [extra_applications: [:logger, :ecto, :mssqlex],
     mod: {Ectotest, []}]
  end

  # Dependencies can be Hex packages:
  #
  #   {:my_dep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:my_dep, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      { :ecto, "~> 2.0" },
      { :mssqlex, "~> 0.8.0" },
      { :mssql_ecto, "~> 0.3.0" },
      { :timex, "~> 3.0" },
      { :tzdata, "~> 0.1.8", override: true },
    ]
  end
end
