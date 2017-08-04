defmodule EctoTest.Worker do
  use Timex
  require Logger

  def start(query) do
    IO.puts "Running on #node-#{ node }"

    ## { :ok, pid } = Mssqlex.start_link(Application.get_env(:ecto_test, EctoTest.Repo))

    { timestamp, response } = Duration.measure(fn ->
      ## Mssqlex.query(pid, query, [], [{ :timeout, :infinity }])
      { :ok, "query", [ num_rows: 10000 ]}
    end)

    handle_response({ Duration.to_milliseconds(timestamp), response })
  end

  defp handle_response({ milliseconds, { :ok, _query, [ num_rows: num_rows ] } }) do
    Logger.info "Worker [#{ node }-#{ inspect self }] successfully read #{ num_rows } row in #{ milliseconds } milliseconds"
  end

  defp handle_response({ _milliseconds, { :error, reason } }) do
    Logger.info "Worker [#{ node }-#{ inspect self }] error due to #{ inspect reason }"
  end

  defp handle_response({ _milliseconds, _ }) do
    Logger.info "Worker [#{ node }-#{ inspect self }] errored out"
    { :error, :unknown }
  end
end
