class SoundWorker
  include Sidekiq::Worker

  def perform(event)
    puts event.inspect
  end
end
