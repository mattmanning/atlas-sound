class SoundWorker
  include Sidekiq::Worker

  SOUNDS = {
    issue_done: 'whoomp_there_it_is.mp3',
    prod_push: 'push_it.mp3',
    sprint_started: 'lets_get_it_started.mp3'
  }

  def perform(event)
    puts event.inspect
    system "omxplayer #{SOUNDS[event.to_sym]}"
  end
end
