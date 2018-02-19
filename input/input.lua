data:extend({
  {
    type = "custom-input",
    name = "heli-up",
    key_sequence = "SHIFT + E",
    consuming = "none"

    -- 'consuming'
    -- available options:
    -- none: default if not defined
    -- all: if this is the first input to get this key sequence then no other inputs listening for this sequence are fired
    -- script-only: if this is the first *custom* input to get this key sequence then no other *custom* inputs listening for this sequence are fired. Normal game inputs will still be fired even if they match this sequence.
    -- game-only: The opposite of script-only: blocks game inputs using the same key sequence but lets other custom inputs using the same key sequence fire.
  },
  {
    type = "custom-input",
    name = "heli-down",
    key_sequence = "SHIFT + Q",
    consuming = "none"
  },

  ------------------

  {
    type = "custom-input",
    name = "heli-zaa-height-increase",
    key_sequence = "Up",
    consuming = "none"
  },

  {
    type = "custom-input",
    name = "heli-zab-height-decrease",
    key_sequence = "Down",
    consuming = "none"
  },

  ------------------

  {
    type = "custom-input",
    name = "heli-zba-toogle-floodlight",
    key_sequence = "SHIFT + L",
    consuming = "none"
  },


  ------------------

  {
    type = "custom-input",
    name = "heli-zca-remote-heli-follow",
    key_sequence = "SHIFT + F",
    consuming = "none"
  },

  {
    type = "custom-input",
    name = "heli-zcb-remote-open",
    key_sequence = "SHIFT + G",
    consuming = "none"
  },
})