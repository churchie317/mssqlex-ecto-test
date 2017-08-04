# Ectotest

Playing around with connecting Mssql to Elixir-Ecto.

* Using the following resources:
  * [SQL Server in Elixir, Part 1: Connecting](http://tech.findmypast.com/sql-server-in-elixir-connection/)
  * [SQL Server in Elixir, Part 2: Process Management](http://tech.findmypast.com/sql-server-in-elixir-gen-server/)
  * [mssqlex](https://github.com/findmypast-oss/mssqlex/)
  * [mssql_ecto](https://github.com/findmypast-oss/mssql_ecto)
  * [Calling A Database Stored Proc Via ODBC From Elixir](https://onor.io/2014/03/18/calling-an-odbc-stored-proc-from-elixir/)

## Usage

### Simple

Once the repository has been cloned down into your repository, run `mix deps.get` to pull in the package dependencies. You'll probably need to update the configuration to accommodate your environment variables in `config/config.exs`. Once downloaded, run `mix escript.build` to compile the scripts into an executable. Run the program with 
```bash
./ectotest -n [num_queries] [query]
```
where num_queries is the number of concurrent queries you wish to run and query is arbitrary SQL code to be executed against your SQL server.

### Distributed

The only difference in execution between the distributed and simple programs are the distributed program requires a registry of slave nodes. Pass your named slave nodes into the `slave_nodes` configuration property in `config/config.exs`. Once those have been added to the configuration file, the distributed program can be run using the same invocation as its simple counterpart.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `ectotest` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:ectotest, "~> 0.1.0"}]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/ectotest](https://hexdocs.pm/ectotest).

