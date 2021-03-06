Wizard.reset universe: true, holospace: true

ExUnit.start()

defmodule IT do
  use ExUnit.Case

  def web(path \\ "") do
    "https://localhost:8443#{ path }"
  end

  def assert_keycode(uuid) do
    assert Regex.match? Help.keycode_regex, uuid
  end

  def assert_web_page(binary) do
    assert Regex.match? ~r/html/i, binary
  end
end
