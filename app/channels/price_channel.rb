class PriceChannel < ApplicationCable::Channel
  def subscribed
    transmit({ message: "Subscribed!" })
  end

  def unsubscribed
    transmit({ message: "Unsubscribed!" })
  end

  def set_symbols(data)
    symbols = Array(data["symbols"])

    symbols.each do |symbol|
      stream_name = "price_channel_#{symbol}"
      stream_from stream_name

      transmit({ message: "Subscribed to #{stream_name}!" })
    end
  end

  def unset_symbols(data)
    symbols = Array(data["symbols"])

    symbols.each do |symbol|
      stream_name = "price_channel_#{symbol}"
      stop_stream_from stream_name

      transmit({ message: "Unsubscribed from #{stream_name}!" })
    end
  end
end
