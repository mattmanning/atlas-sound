class SoundWorker
  include Sidekiq::Worker

  SOUNDS = {
    sprint_started: 'who_let_the_dogs_out.mp3',
    issue_done: 'oh_yeah.mp3'
  }

  def perform(event)
    puts event.inspect
    system "omxplayer #{SOUNDS[event.to_sym]}"
  end
end
