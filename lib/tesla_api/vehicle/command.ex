defmodule TeslaApi.Vehicle.Command do
  import TeslaApi

  defstruct [:success]
  @type t :: %__MODULE__{success: bool()}

  @doc """
  Wakes the vehicle asynchronously. Expected to wait a few seconds to a few minutes before other
  commands will begin to work. A status of `"online"` is necessary before any commands will work.
  """
  @spec wake_up(TeslaApi.Auth.t(), TeslaApi.Vehicle.id()) ::
          TeslaApi.Vehicle.t() | TeslaApi.Error.t()
  def wake_up(%TeslaApi.Auth{token: token}, id) do
    request(:post, "/api/1/vehicles/#{id}/wake_up", token)
    |> TeslaApi.Vehicle.result()
  end

  @doc """
  Honks the horn.
  """
  @spec honk_horn(TeslaApi.Auth.t(), TeslaApi.Vehicle.id()) :: t()
  def honk_horn(%TeslaApi.Auth{token: token}, id) do
    request(:post, "/api/1/vehicles/#{id}/command/honk_horn", token)
    |> result()
  end

  @doc """
  Flashes the lights.
  """
  @spec flash_lights(TeslaApi.Auth.t(), TeslaApi.Vehicle.id()) :: t()
  def flash_lights(%TeslaApi.Auth{token: token}, id) do
    request(:post, "/api/1/vehicles/#{id}/command/flash_lights", token)
    |> result()
  end

  @doc """
  Enables remote start. Password for the account is required.
  """
  @spec remote_start(TeslaApi.Auth.t(), TeslaApi.Vehicle.id(), String.t()) :: t()
  def remote_start(%TeslaApi.Auth{token: token}, id, password) do
    request(:post, "/api/1/vehicles/#{id}/command/remote_start_drive", token, %{
      password: password
    })
    |> result()
  end

  @doc """
  Sets the maximum speed limit for the vehicle.
  """
  @spec set_speed_limit(TeslaApi.Auth.t(), TeslaApi.Vehicle.id(), non_neg_integer()) :: t()
  def set_speed_limit(%TeslaApi.Auth{token: token}, id, limit_mph) do
    request(:post, "/api/1/vehicles/#{id}/command/speed_limit_set_limit", token, %{
      limit_mph: limit_mph
    })
    |> result()
  end

  @doc """
  Activates the maximum speed limit setting for the vehicle.
  """
  @spec speed_limit_activate(TeslaApi.Auth.t(), TeslaApi.Vehicle.id(), String.t()) :: t()
  def speed_limit_activate(%TeslaApi.Auth{token: token}, id, pin) do
    request(:post, "/api/1/vehicles/#{id}/command/speed_limit_activate", token, %{pin: pin})
    |> result()
  end

  @doc """
  Deactivates the maximum speed limit setting for the vehicle.
  """
  @spec speed_limit_deactivate(TeslaApi.Auth.t(), TeslaApi.Vehicle.id(), String.t()) :: t()
  def speed_limit_deactivate(%TeslaApi.Auth{token: token}, id, pin) do
    request(:post, "/api/1/vehicles/#{id}/command/speed_limit_deactivate", token, %{pin: pin})
    |> result()
  end

  @doc """
  Clears the pin required to activate the speed limit maximum.
  """
  @spec speed_limit_clear_pin(TeslaApi.Auth.t(), TeslaApi.Vehicle.id(), String.t()) :: t()
  def speed_limit_clear_pin(%TeslaApi.Auth{token: token}, id, pin) do
    request(:post, "/api/1/vehicles/#{id}/command/speed_limit_clear_pin", token, %{pin: pin})
    |> result()
  end

  @doc """
  Turns on valet mode.
  """
  @spec valet_activate(TeslaApi.Auth.t(), TeslaApi.Vehicle.id(), String.t() | nil) :: t()
  def valet_activate(%TeslaApi.Auth{token: token}, id, pin \\ nil) do
    request(:post, "/api/1/vehicles/#{id}/command/set_valet_mode", token, %{
      on: true,
      password: pin
    })
    |> result()
  end

  @doc """
  Turns off valet mode.
  """
  @spec valet_deactivate(TeslaApi.Auth.t(), TeslaApi.Vehicle.id(), String.t()) :: t()
  def valet_deactivate(%TeslaApi.Auth{token: token}, id, pin) do
    request(:post, "/api/1/vehicles/#{id}/command/set_valet_mode", token, %{
      on: false,
      password: pin
    })
    |> result()
  end

  @doc """
  Clears the valet mode pin.
  """
  @spec valet_reset_pin(TeslaApi.Auth.t(), TeslaApi.Vehicle.id()) :: t()
  def valet_reset_pin(%TeslaApi.Auth{token: token}, id) do
    request(:post, "/api/1/vehicles/#{id}/command/reset_valet_pin", token)
    |> result()
  end

  @doc """
  Unlocks the doors.
  """
  @spec unlock(TeslaApi.Auth.t(), TeslaApi.Vehicle.id()) :: t()
  def unlock(%TeslaApi.Auth{token: token}, id) do
    request(:post, "/api/1/vehicles/#{id}/command/door_unlock", token)
    |> result()
  end

  @doc """
  Locks the doors.
  """
  @spec lock(TeslaApi.Auth.t(), TeslaApi.Vehicle.id()) :: t()
  def lock(%TeslaApi.Auth{token: token}, id) do
    request(:post, "/api/1/vehicles/#{id}/command/door_lock", token)
    |> result()
  end

  @doc """
  Opens the rear trunk.
  """
  @spec trunk(TeslaApi.Auth.t(), TeslaApi.Vehicle.id()) :: t()
  def trunk(%TeslaApi.Auth{token: token}, id) do
    request(:post, "/api/1/vehicles/#{id}/command/actuate_trunk", token, %{which_trunk: "rear"})
    |> result()
  end

  @doc """
  Opens the frunk (in the front).
  """
  @spec frunk(TeslaApi.Auth.t(), TeslaApi.Vehicle.id()) :: t()
  def frunk(%TeslaApi.Auth{token: token}, id) do
    request(:post, "/api/1/vehicles/#{id}/command/actuate_trunk", token, %{which_trunk: "front"})
    |> result()
  end

  @doc """
  Vents the sunroof open (if applicable).
  """
  @spec sunroof_vent(TeslaApi.Auth.t(), TeslaApi.Vehicle.id()) :: t()
  def sunroof_vent(%TeslaApi.Auth{token: token}, id) do
    request(:post, "/api/1/vehicles/#{id}/command/sun_roof_control", token, %{state: "vent"})
    |> result()
  end

  @doc """
  Closes the sunroof (if applicable).
  """
  @spec sunroof_close(TeslaApi.Auth.t(), TeslaApi.Vehicle.id()) :: t()
  def sunroof_close(%TeslaApi.Auth{token: token}, id) do
    request(:post, "/api/1/vehicles/#{id}/command/sun_roof_control", token, %{state: "close"})
    |> result()
  end

  @doc """
  Opens the charger port.
  """
  @spec charge_port_open(TeslaApi.Auth.t(), TeslaApi.Vehicle.id()) :: t()
  def charge_port_open(%TeslaApi.Auth{token: token}, id) do
    request(:post, "/api/1/vehicles/#{id}/command/charge_port_door_open", token)
    |> result()
  end

  @doc """
  Close the charge port.
  """
  @spec charge_port_close(TeslaApi.Auth.t(), TeslaApi.Vehicle.id()) :: t()
  def charge_port_close(%TeslaApi.Auth{token: token}, id) do
    request(:post, "/api/1/vehicles/#{id}/command/charge_port_door_close", token)
    |> result()
  end

  @doc """
  Start charging the vehicle.
  """
  @spec charge_start(TeslaApi.Auth.t(), TeslaApi.Vehicle.id()) :: t()
  def charge_start(%TeslaApi.Auth{token: token}, id) do
    request(:post, "/api/1/vehicles/#{id}/command/charge_start", token)
    |> result()
  end

  @doc """
  Stop charging the vehicle.
  """
  @spec charge_stop(TeslaApi.Auth.t(), TeslaApi.Vehicle.id()) :: t()
  def charge_stop(%TeslaApi.Auth{token: token}, id) do
    request(:post, "/api/1/vehicles/#{id}/command/charge_stop", token)
    |> result()
  end

  @doc """
  Charge to the standard daily setting.
  """
  @spec charge_standard(TeslaApi.Auth.t(), TeslaApi.Vehicle.id()) :: t()
  def charge_standard(%TeslaApi.Auth{token: token}, id) do
    request(:post, "/api/1/vehicles/#{id}/command/charge_standard", token)
    |> result()
  end

  @doc """
  Charge to a full battery.
  """
  @spec charge_max(TeslaApi.Auth.t(), TeslaApi.Vehicle.id()) :: t()
  def charge_max(%TeslaApi.Auth{token: token}, id) do
    request(:post, "/api/1/vehicles/#{id}/command/charge_max_range", token)
    |> result()
  end

  @doc """
  Set the daily charge limit.
  """
  @spec set_charge_limit(TeslaApi.Auth.t(), TeslaApi.Vehicle.id(), non_neg_integer()) :: t()
  def set_charge_limit(%TeslaApi.Auth{token: token}, id, percent) when is_integer(percent) do
    request(:post, "/api/1/vehicles/#{id}/command/set_charge_limit", token, %{percent: percent})
    |> result()
  end

  @doc """
  Turn on the climate control system.
  """
  @spec auto_conditioning_start(TeslaApi.Auth.t(), TeslaApi.Vehicle.id()) :: t()
  def auto_conditioning_start(%TeslaApi.Auth{token: token}, id) do
    request(:post, "/api/1/vehicles/#{id}/command/auto_conditioning_start", token)
    |> result()
  end

  @doc """
  Turn off the climate control system.
  """
  @spec auto_conditioning_stop(TeslaApi.Auth.t(), TeslaApi.Vehicle.id()) :: t()
  def auto_conditioning_stop(%TeslaApi.Auth{token: token}, id) do
    request(:post, "/api/1/vehicles/#{id}/command/auto_conditioning_stop", token)
    |> result()
  end

  @doc """
  Set the internal temperature.
  """
  @spec set_temperature(TeslaApi.Auth.t(), TeslaApi.Vehicle.id(), float, float) :: t()
  def set_temperature(%TeslaApi.Auth{token: token}, id, driver_celcius, passenger_celcius)
      when is_number(driver_celcius) and is_number(passenger_celcius) do
    request(:post, "/api/1/vehicles/#{id}/command/set_temps", token, %{
      driver_temp: driver_celcius,
      passenger_temp: passenger_celcius
    })
    |> result()
  end

  @doc """
  Turn on a seat heater.
  """
  @spec seat_heater(TeslaApi.Auth.t(), TeslaApi.Vehicle.id(), 0..4, 0..3) :: t()
  def seat_heater(%TeslaApi.Auth{token: token}, id, seat, level)
      when seat in 0..4 and level in 0..3 do
    request(:post, "/api/1/vehicles/#{id}/command/remote_seat_heater_request", token, %{
      heater: seat,
      level: level
    })
    |> result()
  end

  @doc """
  Toggle media playback.
  """
  @spec media_toggle(TeslaApi.Auth.t(), TeslaApi.Vehicle.id()) :: t()
  def media_toggle(%TeslaApi.Auth{token: token}, id) do
    request(:post, "/api/1/vehicles/#{id}/command/media_toggle_playback", token)
    |> result()
  end

  @doc """
  Media next track.
  """
  @spec media_next(TeslaApi.Auth.t(), TeslaApi.Vehicle.id()) :: t()
  def media_next(%TeslaApi.Auth{token: token}, id) do
    request(:post, "/api/1/vehicles/#{id}/command/media_next_track", token)
    |> result()
  end

  @doc """
  Media previous track.
  """
  @spec media_prev(TeslaApi.Auth.t(), TeslaApi.Vehicle.id()) :: t()
  def media_prev(%TeslaApi.Auth{token: token}, id) do
    request(:post, "/api/1/vehicles/#{id}/command/media_prev_track", token)
    |> result()
  end

  @doc """
  Media next favorite track.
  """
  @spec media_next_fav(TeslaApi.Auth.t(), TeslaApi.Vehicle.id()) :: t()
  def media_next_fav(%TeslaApi.Auth{token: token}, id) do
    request(:post, "/api/1/vehicles/#{id}/command/media_next_track_fav", token)
    |> result()
  end

  @doc """
  Media previous favorite track.
  """
  @spec media_prev_fav(TeslaApi.Auth.t(), TeslaApi.Vehicle.id()) :: t()
  def media_prev_fav(%TeslaApi.Auth{token: token}, id) do
    request(:post, "/api/1/vehicles/#{id}/command/media_prev_track_fav", token)
    |> result()
  end

  @doc """
  Volume up.
  """
  @spec media_volume_up(TeslaApi.Auth.t(), TeslaApi.Vehicle.id()) :: t()
  def media_volume_up(%TeslaApi.Auth{token: token}, id) do
    request(:post, "/api/1/vehicles/#{id}/command/media_volume_up", token)
    |> result()
  end

  @doc """
  Volume down.
  """
  @spec media_volume_down(TeslaApi.Auth.t(), TeslaApi.Vehicle.id()) :: t()
  def media_volume_down(%TeslaApi.Auth{token: token}, id) do
    request(:post, "/api/1/vehicles/#{id}/command/media_volume_down", token)
    |> result()
  end

  @doc """
  Send an address to the navigation system.
  """
  @spec navigate_to(TeslaApi.Auth.t(), TeslaApi.Vehicle.id(), String.t()) :: t()
  def navigate_to(%TeslaApi.Auth{token: token}, id, address) when is_binary(address) do
    request(:post, "/api/1/vehicles/#{id}/command/media_volume_down", token, %{
      :type => "share_ext_content_raw",
      :locale => "en-US",
      :timestamp_ms => DateTime.utc_now() |> DateTime.to_unix(),
      "value[android.intent.extra.TEXT]" => address
    })
    |> result()
  end

  @doc """
  Schedule an available software update.
  """
  @spec schedule_software_update(TeslaApi.Auth.t(), TeslaApi.Vehicle.id(), non_neg_integer) :: t()
  def schedule_software_update(%TeslaApi.Auth{token: token}, id, seconds_until_install)
      when is_integer(seconds_until_install) do
    request(:post, "/api/1/vehicles/#{id}/command/media_volume_down", token, %{
      offset_sec: seconds_until_install
    })
    |> result()
  end

  @doc """
  Cancel the software update.
  """
  @spec cancel_software_update(TeslaApi.Auth.t(), TeslaApi.Vehicle.id()) :: t()
  def cancel_software_update(%TeslaApi.Auth{token: token}, id) do
    request(:post, "/api/1/vehicles/#{id}/command/media_volume_down", token)
    |> result()
  end

  defp result({:ok, %Tesla.Env{}}) do
    %__MODULE__{success: true}
  end

  defp result({:error, %Tesla.Env{}}) do
    %__MODULE__{success: false}
  end
end
