class SoundWorker
  include Sidekiq::Worker

  SOUNDS = {
    issue_done: 'oh_yeah.mp3',
    prod_push: 'push_it.mp3',
    sprint_started: 'lets_get_ready_to_rumble.mp3'
  }

  def perform(event)
    puts event.inspect
    system "omxplayer #{SOUNDS[event.to_sym]}"
  end
end
