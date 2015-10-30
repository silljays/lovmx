# defmodule Holo.Test do
#   use ExUnit.Case
#
#   test "Use `Holo.map` to get a map of everything.", do:
#     assert is_map Holo.map
#
#   # test "Use `Holo.boost` and `Holo.space` to get/set things in <holospace>." do
#   #   data = %Data{} = Holo.boost Data.new, "whoa"
#   #
#   #   assert data in Holo.space data.keycod
#   # end
#
#   test "Use `Holo.list` to get a list of everything.", do:
#     assert is_list Holo.list
#
#   test "Use `Holo.move` to move data to a new home.", do:
#     assert %Data{home: "bot"} = Holo.move Data.new, "bot"
#
#   test "Use `Holo.boost <holospace>` to return holospace data." do
#     key = Help.keycode
#
#     one = "one" |> Data.new |> Holo.boost key
#     assert [one] = Holo.space(key)
#
#     two = "two" |> Data.new |> Holo.boost key
#     assert [one, two] = Holo.space(key)
#   end
#
#   test "Use `Holo.forget <holospace>` to forget *ALL* holospace data.", do:
#     assert "nolols" == Holo.forget("nolols", "passcode")
#
#   test "Use `Holo.capture` to exclusively put something in holospace.", do:
#     assert %Data{} = Holo.capture Data.new("lockdown"), "ctf"
#
# end
