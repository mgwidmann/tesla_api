defmodule TeslaApi.Vehicle do
  import TeslaApi

  alias TeslaApi.{Result, Error, Auth}

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
  @spec list(Auth.t()) :: {:ok, list(t())} | {:error, Error.t()}
  def list(%Auth{token: token}) do
    request(:get, "/api/1/vehicles", token)
    |> result()
  end

  @doc """
  Gets the vehicle data without any extra state data. Requires the vehicle to be awake.
  """
  @spec get(Auth.t(), id()) :: {:ok, t()} | {:error, Error.t()}
  def get(%Auth{token: token}, id) do
    request(:get, "/api/1/vehicles/#{id}", token)
    |> result()
  end

  @doc """
  Gets the vehicle with all supporting charge, drive, climate, gui, vehicle state and
  vehicle config data at once. Requires the vehicle to be awake.
  """
  @spec get_with_state(Auth.t(), id()) :: {:ok, t()} | {:error, Error.t()}
  def get_with_state(%Auth{token: token}, id) do
    request(:get, "/api/1/vehicles/#{id}/vehicle_data", token)
    |> result()
  end

  @doc """
  Returns nearby charging sites close to the vehicle.
  """
  @spec nearby_charging_sites(Auth.t(), id()) :: {:error, Error.t()} | {:ok, map}
  def nearby_charging_sites(%Auth{token: token}, id) do
    case request(:get, "/api/1/vehicles/#{id}/nearby_charging_sites", token) do
      {:ok, %Tesla.Env{body: %{"response" => response}}} -> {:ok, response}
      {:error, e} -> %Error{env: e}
    end
  end

  @doc false
  def result(response) do
    Result.handle(response, &vehicle_result/1)
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
