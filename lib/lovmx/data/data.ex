require Logger

defmodule Data do
  
  @moduledoc """
  # Data
  ## Tree of Life.
  ### Computable Input/Output.
  
  Data is both a particle (module) *and* a wave (capture/flow). 
  Data changes, thats the secret. We create Data and we *change* 
  Data.
  
  There are sixteen basic datas in the whole everything. See `cake.ex`
  and `Kind` for more info on data types.
  
  In force, LovMx always tries to apply a Data-first design. Then 
  we try to meet the functional, reactive, and monadic-like approaches,
  and try to keep each module as focused and DRY as possible at the
  highest abstraction and resemblance to natural language that we can.

  Then we try to make the compsci bits nice for the Bots.
  
  Our `use Magic` include and `use OrbitalMagic` simply combine
  as many of our custom APIs as we can fit onto generic Flow Based 
  Programming in Elixir. 
  
  #note: Our data/flow struct size is pretty big but we can make it
  fast and imagine lots of easy behind the scenes struct mutations and
  optimization down the road. Or you know, we all chooose to deal with 
  big packets..
  
  #note: the main focus has been to get a beautiful API nailed down at
  all cost. Then make it work. Then make it stream/concurrent. Then fast. 
  
  There are lots of #todos left, and we will be bootstrapping a code
  bounty on lovmx.com or internally @lovmx> at some point.
  """
  
  defstruct keycode: nil,
    home: nil,    # <process> or <secret> or <holospace>
    kind: nil,    # default to :boot or see `Kind` + `cake.ex`
    time: nil,    # genesis/duration/etc
    life: nil,    # microseconds/duration/expiration
    
    meta: %{},    # %{} a metadata map
    help: [],     # [messages] notes/readme
    boom: [],     # [errors/exceptions]
    
    pull: %{},    # *startup* input (aka ROM)
    code: [],     # [functions] current program
    push: %{},    # *output* ports  (aka Post)
    thing: nil,   # *computed* data (aka CPU)
    
    tick: 0,      # epoch/time/version
    roll: [],     # *previous* data (aka Backup)
    jump: %{},    # *potential* data
    ping: %{}     # *latest/social* (aka Social)

  @derive [Enumerable]
  
  ## Creating Data - See `flow.ex` and `pipe.ex` for more about data flows.
  
  @doc "Use `Data.new` to create new Data from thing `real` data."
  def new(thing \\ nil, kind \\ Kind.boot, meta \\ %{}) do
    data = %Data{
        keycode: Help.path(["data", Help.keycode]),
           kind: kind,
           time: Moment.now,
           life: Help.long,
           meta: Map.merge(%{}, meta || %{}),
          thing: thing
    }
  end
    
  @doc "Give `data` a new home at `process`."
  def home(data = %Data{}, process) when is_pid(process) do
    # update the data
    Data.tick(put_in data.home, process)
  end
  
  @doc "Use `Data.tick` to create a temporal notation (aka version) of `data` at this time."
  def tick(data = %Data{}, opts \\ []) do
    version = data
    
    # save + update
    data = put_in(data.roll, Enum.concat(data.roll, [Data.address(data)]))
    
    # are we completely rebooting this tick?
    if reboot = Keyword.get(opts, :reboot, false) do
      data = put_in data.jump, %{}
      data = put_in data.pull, %{}
    
      # blank the :pulls so next time through it'll re-flow w/ fresh data
      Enum.map data.pull, fn {key, value} ->
        data = put_in data.pull, Map.put(data.pull, key, Kind.boot)
      end
    end
    
    # Update the world.
    data = put_in(data.tick, data.tick + 1)
  end
  
  @doc "Use `Kind.meta` controls to help the data flow."
  def meta(data = %Data{}, signal, effect \\ nil) do
    put_in(data.meta, Map.put(data.meta, signal, effect))
  end

  @doc "Use `Data.kind` to mutate the data type using custom or Kind types."
  def kind(data = %Data{}, kind \\ Data.boot) do
    data = put_in data.kind, kind
  end
  
  @doc "Readme first."
  def help(data = %Data{}, message) do
    put_in(data.help, Enum.concat(data.help, [message]))
  end
  
  @doc "Add executable `code` to Data."
  def code(text) when is_binary(text) do
    # todo: better update meta
    text
    |> Data.new
    |> Cake.magic
  end
  def code(function) when is_function(function) do
    code Data.new, function
  end
  def code(data = %Data{}, function) when is_function(function) do
    # todo: better update meta
    Data.tick put_in(data.code, Enum.concat(data.code, [function]))
  end
  def code(block = [do: _]) do
    code Data.new, block
  end
  def code(data = %Data{}, block = [do: _]) do
    code data, fn data ->
      block
    end
  end
  def code(data = %Data{home: bot}, holospace \\ nil, secret \\ nil, duration \\ nil) when is_pid(bot) do
    GenServer.call data.home, {:code, holospace, secret, duration}
  end
  
  @doc "Return *current* `data.thing`."
  def thing(data = %Data{}) do
    # todo: get the data from holo
    
    data.thing
  end
    
  @doc "Return inside `data` at `path`."
  def path(data = %Data{}, path) when is_atom(path) or is_binary(path) do
    Map.get data.pull, path
  end
  def path(path, data = %Data{}) when is_atom(path) or is_binary(path) do
    Map.get data.pull, path
  end
  
  @doc "Morph Data into whatever `function` returns."
  def morph(data = %Data{}, function) when is_function(function) do
    # Data can morph, return whatever Data or other thing from function
    function.(data)
  end
  
  @doc "Genetic Clone."
  def clone(data = %Data{}) do
    clone = Data.new
    clone = put_in clone.help,  data.help
    clone = put_in clone.code,  data.code
    clone = put_in clone.pull,  data.pull
    clone = put_in clone.push,  data.push

    clone
  end

  @doc "Add an error `message` to Data."
  def boom(data = %Data{}, message) when not is_nil(message) do
    Data.tick put_in(data.boom, List.flatten [List.wrap(message)|data.boom])
  end
  
  @doc "Return playback information for `data`."
  def address(data = %Data{}, opts \\ []) do
    # get the queried version or the current version - 1
    version = Keyword.get opts, :tick, data.tick
    
    if version == :back do
      if data.tick > 0 do
        version = data.tick - 1
      else
        version = data.tick
      end
    end
    
    Help.path [data.keycode, "#{version}"]
  end
  
  @doc "Rollback `data` to a previous version."  
  def roll(data = %Data{}, opts) do
    roll address(data, opts)
  end
  def roll(holospace) when is_atom(holospace) or is_binary(holospace) do
    Drive.read Help.web holospace
  end
  
  @doc "Jump data to an unknown future if exe `code` passes `test`."
  def jump(data = %Data{}, holospace, code, test) do
    result = code.(data)
    
    if test.(result) do
      data = put_in(data.jump, Map.put(data.jump, holospace, result))
      |> Data.tick
    else
      data
    end
  end
  
  ## Meta/Error/Exception
  
  def boom(error) do
    error
    |> Data.new
    |> Data.kind(Kind.boom)
    |> Data.tick
  end
  def boom(data, error \\ nil) do
    %{ data | boom: Enum.concat(data.boom, [error]) }
    |> Data.tick
  end
  
end