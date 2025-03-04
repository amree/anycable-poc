class PriceChannel < ApplicationCable::Channel
  def subscribed
    stream_from "price_channel"

    transmit({ message: "Subscribed!" })
  end

  def unsubscribed
    transmit({ message: "Unsubscribed!" })
  end
end
