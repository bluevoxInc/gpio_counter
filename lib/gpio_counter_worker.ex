defmodule GpioCounter.Worker do
  use GenServer

  @up_pin 22
  @down_pin 17
  @ones_pin 24
  @twos_pin 23
  @fours_pin 18
	
  def start_link(name) do
    IO.puts "Starting gpio counter"
    GenServer.start_link(__MODULE__, nil, name: name)
  end

  def init(_) do
    Process.flag(:trap_exit, true)

    {:ok, upPin} = Gpio.start_link(@up_pin, :input)		
    {:ok, downPin} = Gpio.start_link(@down_pin, :input)
    :ok = Gpio.set_int(upPin, :rising)
    :ok = Gpio.set_int(downPin, :rising)
    {:ok, onesPin} = Gpio.start_link(@ones_pin, :output)
    {:ok, twosPin} = Gpio.start_link(@twos_pin, :output)
    {:ok, foursPin} = Gpio.start_link(@fours_pin, :output)

    IO.puts "GPIO #{@up_pin} counts up and GPIO #{@down_pin} counts down.\n"
    {:ok, Map.new([{:count, 0}, {:up_pin, upPin}, {:down_pin, downPin}, {:ones_pin, onesPin}, {:twos_pin, twosPin}, {:fours_pin, foursPin}])}
  end

  def handle_call(_request, _from, state) do
    {:reply, :ok, state}
  end

  def handle_cast(_msg, state) do
    {:noreply, state}
  end

  def handle_info({:gpio_interrupt, @up_pin, :rising}, %{:count => n} = gpio_state) when n < 7 do
    newCount = n + 1
    set_counter_pins(gpio_state, newCount)
    {:noreply, Map.put(gpio_state, :count, newCount)}
  end

  def handle_info({:gpio_interrupt, @down_pin, :rising}, %{:count => n} = gpio_state) when n > 0 do
    newCount = n - 1
    set_counter_pins(gpio_state, newCount)
    {:noreply, Map.put(gpio_state, :count, newCount)}
  end

  def handle_info({:gpio_interrupt, _pin, _condition}, state) do
    {:noreply, state}
  end

  def terminate(_reason, state) do
    set_counter_pins(state, 0)	
    :ok		
  end

  defp set_counter_pins(%{:ones_pin => onesPin, :twos_pin => twosPin, :fours_pin => foursPin}, count) do
    <<fours :: 1, twos :: 1, ones :: 1>> = <<count :: 3>>	
    Gpio.write(onesPin, ones)
    Gpio.write(twosPin, twos)
    Gpio.write(foursPin, fours)
  end

end
