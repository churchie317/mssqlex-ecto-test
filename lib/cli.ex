use Mix.Config
defmodule EctoTest.CLI do
  require Logger

  def main(args) do
    ## Start master node in distributed mode
    # Because this is a command line application, the master node cannot be started
    # via the CLI
    Application.get_env(:ectotest, :master_node)
    |> Node.start

    ## Connect slave nodes to master node
    Application.get_env(:ectotest, :slave_nodes)
    |> Enum.each(&Node.connect/1)

    ## Handle CLI arguments, where node is an native function returning the current (master) node
    args
    |> parse_args
    |> process_options([ node | Node.list ])
  end

  ## Nifty function that parses CLI args; see more here: https://hexdocs.pm/elixir/OptionParser.html
  defp parse_args(args) do
    OptionParser.parse( args,
      aliases: [ n: :numqueries ],
      strict: [ numqueries: :integer ])
  end

  defp process_options(options, nodes) do
    case options do
      {[ numqueries: numqueries ], [ query ], []} ->
        do_queries(numqueries, query, nodes)

      _ ->
        do_help
    end
  end

  defp do_queries(num_queries, query, nodes) do
    Logger.info """
    Testing concurrent queries:

        #{ query }

    across #{ length nodes } node(s).
    """

    total_nodes = length nodes
    queries_per_node = div(num_queries, total_nodes)

    nodes
    |> Enum.flat_map(fn nodes ->
      # Yo dawg, can you some of those tasks https://hexdocs.pm/elixir/Task.html#module-distributed-tasks
      1..queries_per_node
      |> Enum.map(fn _ ->
        # Spawn an asynchronous task performed by a worker pid, supervised by the named TasksSupervisor module
        Task.Supervisor.async({ EctoTest.TasksSupervisor, node }, EctoTest.Worker, :start, [ query ]) end)
      end)
      |> Enum.map(&Task.await(&1, :infinity))
      |> parse_results
  end

  defp parse_results(tasks) do
    ## Split results into tuple of list of trues where Tasks succeeded and falses where they failed
    results = tasks
    |> Enum.split_with(fn { msg_type, _ } -> msg_type == :ok end)

    { successes, _failures } = results

    total_workers = Enum.count tasks
    total_success = Enum.count successes
    total_failure = total_workers - total_success

    data = successes |> Enum.map(fn { :ok, time } -> time end)
    average_time = average data
    longest_time = Enum.max data
    shortest_time = Enum.min data

    Logger.info """
    Total queries         : #{ total_workers }
    Successful queries    : #{ total_success }
    Failed queries        : #{ total_failure }
    Average (msecs)       : #{ average_time }
    Shortest query (msecs): #{ shortest_time }
    Longest query (msces) : #{ longest_time }
    """
  end

  defp average(data) do
    sum = data |> Enum.sum
    ## Prevent 'divide by zero' error
    if sum > 0 do
      sum / data |> length
    else
      0
    end
  end

  defp do_help do
    IO.puts """
    Usage:
    ectotest -n [num_queries] [query]

    Options:
    -n, [--numqueries] #Number of queries

    Example:
    ./ectotest -n 1_000 "SELECT * FROM <table_name>"
    """
    ## Exit with zero stat code
    System.halt(0)
  end
end
