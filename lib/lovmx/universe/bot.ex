require Logger

defmodule Bot do
  
  @moduledoc """
  # Bot
  ## Bot(s) are a module to map `code` + `data` to `holospace` Machine(s).
  ### aka. Globally Persistent Code and Data Storage Component(s).
  
  Bot are animated and friendly little helpers.

  Bot like to eat `Cake` and write code for `Data` and `Player`s
  and should be considered when interacting with any native, 
  static, primitive, or holospace based object(s) in need of 
  holographic intelligence.

  Good Bot should be fun, simple, and enjoy `Cake` immensely.

  Learn more:
  https://lovmx.com/help/bot
  
  Or on the web:
  https://en.wikipedia.org/wiki/Persistent_data_structure
  
  tl;dr - Bot(s) manage Code for Machine Data. 
  """
  
  # Forward Signal/Kinds to Machine(s).
  
  def drop(data = %Data{home: machine}, holospace \\ nil, secret \\ nil, duration \\ nil) when is_pid(machine) do
    GenServer.call data.home, {:stop, holospace, secret, duration}
  end
  
  def boot(data = %Data{home: machine}, signal, effect \\ nil) when is_pid(machine) do
    GenServer.call data.home, {:meta, signal, effect}
  end
  
  def lock(data = %Data{home: machine}, signal, effect \\ nil) when is_pid(machine) do
    GenServer.call data.home, {:meta, signal, effect}
  end
  
  def meta(data = %Data{home: machine}, signal, effect \\ nil) when is_pid(machine) do
    GenServer.call data.home, {:meta, signal, effect}
  end
  
  def list(data = %Data{home: machine}, holospace \\ nil, secret \\ nil, duration \\ nil) when is_pid(machine) do
    GenServer.call data.home, {:list, holospace, secret, duration}
  end
  
  def pull(data = %Data{}) do
    Tube.read Lovmx.web ["#{data.tick}", data.keycode]
  end
  def pull(data = %Data{home: machine}, holospace \\ nil, secret \\ nil, duration \\ nil) when is_pid(machine) do
    GenServer.call data.home, {:pull, holospace, secret, duration}
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
  def code(data = %Data{home: machine}, holospace \\ nil, secret \\ nil, duration \\ nil) when is_pid(machine) do
    GenServer.call data.home, {:code, holospace, secret, duration}
  end
  
  def push(data = %Data{home: machine}, holospace \\ nil, secret \\ nil, duration \\ nil) when is_pid(machine) do
    GenServer.call data.home, {:flow, holospace, secret, duration}
  end
  
  def flow(data = %Data{home: machine}, holospace \\ nil, secret \\ nil, duration \\ nil) when is_pid(machine) do
    GenServer.call data.home, {:data, holospace, secret, duration}
  end
    
  def wait(data = %Data{home: machine}, holospace \\ nil, secret \\ nil, duration \\ nil) when is_pid(machine) do
    # TODO: item this up
    Data.code(data, fn x ->
      Holo.share x, IO.gets :stdin
    end)
  end
  
end