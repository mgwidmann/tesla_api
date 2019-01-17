defmodule TeslaApi.Vehicle do
  import TeslaApi

  @type id() :: integer()
  @type vehicle_id :: integer()

  defstruct id: nil,
            vehicle_id: nil,
            vin: nil,
            tokens: [],
            state: "unknown",
            option_codes: [],
            in_service: false,
            display_name: nil,
            color: nil,
            calendar_enabled: nil,
            backseat_token: nil,
            backseat_token_updated_at: nil,
            api_version: nil,
            charge_state: nil,
            climate_state: nil,
            drive_state: nil,
            gui_settings: nil,
            vehicle_config: nil,
            vehicle_state: nil

  @type t :: %__MODULE__{id: id(), vehicle_id: vehicle_id()}

  @doc """
  Gets a list of all the vehicles for the account. Does not require any of the vehicles to be awake.
  """
  @spec list(TeslaApi.Auth.t()) :: list(__MODULE__.t())
  def list(%TeslaApi.Auth{token: token}) do
    request(:get, "/api/1/vehicles", token)
    |> results()
  end

  @doc """
  Gets the vehicle data without any extra state data. Requires the vehicle to be awake.
  """
  @spec get(TeslaApi.Auth.t(), id()) :: __MODULE__.t()
  def get(%TeslaApi.Auth{token: token}, id) do
    request(:get, "/api/1/vehicles/#{id}", token)
    |> result()
  end

  @doc """
  Gets the vehicle with all supporting charge, drive, climate, gui, vehicle state and
  vehicle config data at once. Requires the vehicle to be awake.
  """
  @spec get_with_state(TeslaApi.Auth.t(), id()) :: __MODULE__.t()
  def get_with_state(%TeslaApi.Auth{token: token}, id) do
    request(:get, "/api/1/vehicles/#{id}/vehicle_data", token)
    |> result()
  end

  @doc """
  Returns nearby charging sites close to the vehicle.
  """
  @spec nearby_charging_sites(TeslaApi.Auth.t(), id()) ::
          TeslaApi.Error.t() | map() | TeslaApi.Error.t()
  def nearby_charging_sites(%TeslaApi.Auth{token: token}, id) do
    case request(:get, "/api/1/vehicles/#{id}/nearby_charging_sites", token) do
      {:ok, %Tesla.Env{body: response}} -> response
      {:error, e} -> %TeslaApi.Error{env: e}
    end
  end

  @doc false
  @spec results({:ok | :error, Tesla.Env.t()}) :: TeslaApi.Error.t() | list(__MODULE__.t())
  def results({:ok, %Tesla.Env{status: status, body: %{"response" => vehicles}}})
      when status >= 200 and status <= 299 do
    vehicles
    |> Enum.map(&vehicle_result/1)
  end

  def results({:ok, %Tesla.Env{status: 408, body: %{"error" => "vehicle unavailable:" <> _}}}) do
    %TeslaApi.Error{
      message: "Vehicle unavailable. The vehicle must be woken up to make this API call succeed."
    }
  end

  def results({:error, e = %Tesla.Env{}}) do
    %TeslaApi.Error{message: "An unknown error has occurred.", env: e}
  end

  @doc false
  @spec result({:ok | :error, Tesla.Env.t()}) :: TeslaApi.Error.t() | __MODULE__.t()
  def result({:ok, %Tesla.Env{status: status, body: %{"response" => vehicle}}})
      when status >= 200 and status <= 299 do
    vehicle_result(vehicle)
  end

  def result({:ok, %Tesla.Env{status: 408, body: %{"error" => "vehicle unavailable:" <> _}}}) do
    %TeslaApi.Error{
      error: :vehicle_unavailable,
      message: "Vehicle unavailable. The vehicle must be woken up to make this API call succeed."
    }
  end

  def result({:error, e = %Tesla.Env{}}) do
    %TeslaApi.Error{message: "An unknown error has occurred.", env: e}
  end

  defp vehicle_result(vehicle) do
    %__MODULE__{
      id: vehicle["id"],
      vehicle_id: vehicle["vehicle_id"],
      vin: vehicle["vin"],
      tokens: vehicle["tokens"],
      state: vehicle["state"] || "unknown",
      option_codes: String.split(vehicle["option_codes"] || "", ","),
      in_service: vehicle["in_service"],
      display_name: vehicle["display_name"],
      color: vehicle["color"],
      calendar_enabled: vehicle["calendar_enabled"],
      backseat_token: vehicle["backseat_token"],
      backseat_token_updated_at: vehicle["backseat_token_updated_at"],
      api_version: vehicle["api_version"],
      charge_state:
        if(vehicle["charge_state"],
          do: __MODULE__.State.Charge.charge_result(vehicle["charge_state"]),
          else: nil
        ),
      climate_state:
        if(vehicle["climate_state"],
          do: __MODULE__.State.Climate.climate_result(vehicle["climate_state"]),
          else: nil
        ),
      drive_state:
        if(vehicle["drive_state"],
          do: __MODULE__.State.Drive.drive_result(vehicle["drive_state"]),
          else: nil
        ),
      gui_settings:
        if(vehicle["gui_settings"],
          do: __MODULE__.State.Gui.gui_result(vehicle["gui_settings"]),
          else: nil
        ),
      vehicle_config:
        if(vehicle["vehicle_config"],
          do: __MODULE__.State.VehicleConfig.vehicle_config_result(vehicle["vehicle_config"]),
          else: nil
        ),
      vehicle_state:
        if(vehicle["vehicle_state"],
          do: __MODULE__.State.VehicleState.vehicle_state_result(vehicle["vehicle_state"]),
          else: nil
        )
    }
  end
end
