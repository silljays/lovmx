require Logger

defmodule Kind do
  
  @moduledoc """
  # Kind
  ## Data Types / Data Signals

  # We use the module Kind to get one useful namespace word
  # that flows well in source code and natural language. Kind is
  # an abstract signal-like query notion. A `Freezer.list` may look 
  # differently then what a `News.list` result would be and
  # certainly different than a `html([results], Kind.list)` call
  # may use. So if we think about `Data` as being *unmanifested*
  # energy (all potential flowing data) then Kind almost becomes 
  # the first query/tag/category we can put on `Data` before
  # collecting it.
  
  # From the start of `Kind` module usage we always work toward natural
  # language and common sense naming. Take great, great care
  # in naming.
  """
  
  ## Flow Controls
  def flow, do: :flow      # run/exe/produce
  def init, do: :init      # new/fresh
  def meta, do: :meta      # meta/control
  def list, do: :list      # show/head/etc
  def pull, do: :pull      # pull/get/read 
  def code, do: :code      # source/code
  def push, do: :push      # push/post/update
  def stub, do: :stub      # promise/future
  def wait, do: :wait      # noop/drop
  def stop, do: :stop      # halt/stop
  
  ## Item Prototypes
  def text,   do: :text    # binary/text
  def link,   do: :link    # a path/URI/link
  def html,   do: :html    # an html snippet
  def blob,   do: :blob    # static/binary
  def cake,   do: :cake    # cake/orbitalmagic
  
end

defmodule Cake do
  
  @moduledoc """
  # Cake
  ## Sugary sweet Cloud App texting language
  ### Build industrial strength Orbital Magic apps in Seconds.
  
  All energy/matter/vibration of Nubspace is Cake.
  And it's Cake all the way down. Except for the `binary`
  that sits below Cake and which *ALL* calls should return. 
  Then it looks more like: CakeN > CakeN+1 > binary.
  
  Cake is a fun + simple Cloud App texting language for bringing
  Orbital Magic to your app. The idea is we type mostly plain 
  English code words like @share> homevideo.mp4 to activate ILvMx 
  Special Super Powers anywhere regular text is accepted. We
  then build up a world writable file system network of Cake
  documents and when one is executed it dynamically pulls
  all the data into a Markdown document, which then becomes
  the app the Player is using. Of course each and every one of 
  our actual users and user agents are connected to either their 
  very own Castle server (aka VPN/VPS) or connected to one of the 
  community free, shared, and moderated Castles.
    
  All energy/matter/vibration of Nubspace is Cake.
  And it's Cake all the way down. Except for the `binary`
  that sits below Cake and which *ALL* calls should return. 
  Then it looks more like: Cake > Cake > binary.
  
  For examples see `README.magic` or @help, #help, #cake, etc.
  """
  
  @moduledoc "Use `Cake` to build industrial strength Orbital Magic apps."
  
  ##    *     *     *     *     *     *     *     *     *
  ##   |||   |||   |||   |||   |||   |||   |||   |||   |||   
  ## #######################################################
  ## ## Magic is powered by Cake ###########################
  ## #######################################################
  
  @doc "Machine a file at `path`."
  def mix(path) when is_binary(path) do
    #Logger.debug "Cake.mix #{path}"

    # scrub
    path = path |> Lovmx.path?

    # best effort the file..
    case Path.extname(path) do
      ".exs"    -> {data, _} = Code.eval_file(path)        
      ".eex"    -> EEx.eval_string Tube.read(path), assigns: []
      ".magic"  -> Tube.read(path) |> Cake.magic
      _ ->
        Data.bugs("#weird `#{path}` *seems* to have a problem...")
    end
  end
  
  @doc "Render a template from `path` and render the template with our Data."
  def kit(path) do
    EEx.eval_file Lovmx.web path
  end
  def kit(data = %Data{}, path) do
    EEx.eval_file Lovmx.web(path), assigns: [data: data]
  end
  
  def magic(text) when is_binary(text) do
    magic Data.new text
  end
  def magic(data = %Data{native: text}) when is_binary(text) do
    ##Logger.debug "Cake.magic: #{inspect text} // #{inspect data}"
    
    # we are a superset of markdown, so mark it first..
    text = Pipe.down(text)
    ##Logger.debug "Cake.magic2: #{inspect text} // #{inspect data}"
    
    # our magicdown regex.
    match = ~r/[^|\s]{0,}\@([a-z0-9]{2,})\>\s([a-z0-9\#\%\?\s]{2,})/i

    # compile Data + markup from original simple text
    cake = Regex.replace match, text, fn(cap, code, opts) ->
      {data, replace} = x(data, cap, code, opts)
      
      replace
    end
    #Logger.debug "Cake.magic3: #{inspect text} // #{inspect data}"
    
    # then flow it baby
    Flow.into(cake, data, Kind.cake)
  end
  def magic(nada) when is_nil(nada) do
    # there is no magic here.. :(
    
    nil
  end
  
  # def x(data = %Data{}, signal, "code", source) do
  #   #Logger.debug "#path // #{inspect signal} // #{inspect data}"
  #
  #   data = Bot.code(data, source)
  #   #Logger.debug "#code // #{inspect source }"
  #
  #   {data, Pipe.text(source)}
  # end
  def x(data = %Data{}, signal, "list", path) do  
    # get the list
    list = Holo.list(path)
    #Logger.debug "#list // #{inspect list}"
    
    {Data.renew(data, list), Pipe.text(list)}
  end
  def x(data = %Data{}, signal, code, opts) do
    #Logger.debug "#signal // #{inspect signal } // #{inspect code} // #{inspect opts}"
    
    # todo: spawn(signal, code.to_existing_atom, [opts])
    
    {data, code}
  end
    
end

defmodule Magic do
  
  @moduledoc "Use `Magic` to optimize your Elixir."
  
  defmacro __using__(_options) do
    quote do
            
      Code.ensure_loaded Data
      import Data

      Code.ensure_loaded Flow
      import Flow
      
      Code.ensure_loaded Pipe
      import Pipe

      Code.ensure_loaded Holo
      import Holo
      
      Code.ensure_loaded Tube
      import Tube

      Code.ensure_loaded Cake
      import Cake
    end
  end
  
end

defmodule OrbitalMagic do
    
  @moduledoc "Use `OrbitalMagic` for easy web apps."
  
  defmacro __using__(_options) do
    quote do

      import Plug.Conn
      use Plug.Router
      use Plug.Builder
      plug :match
      plug :dispatch
      use WebAssembly
      
    end
  end
  
end

defmodule OrbitalMaru do
  
  @moduledoc "Use `OrbitalMaru` for easy HTTP APIs."
  
  defmacro __using__(_options) do
    quote do

      import Plug.Conn
      use Maru.Router
      plug Plug.Logger
      use WebAssembly
    end
  end
  
end
