# GpioCounter

This is a demonstration Elixir program is for use on Raspberry Pi. 

The build is on Erlang/OTP 18, Elixir 1.4.0, Linux raspberrypi 3.12.22+ platform.

This application is based on the Erlang_ale example gpio_counter program. 

The code utilizes the elixir_ale (https://github.com/fhunleth/elixir_ale) GPIO module to build a binary counter. Wire your board according to the elixir_ale README GPIO section. Install this code, run mix deps.get, and then run iex -S mix from your linux terminal. The application automically starts and then you can actuate the buttons to see the led's count up and down. Great fun for someone who want to start with the basics.
