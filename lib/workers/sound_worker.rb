class SoundWorker
  include Sidekiq::Worker

  SOUNDS = {
    issue_done: 'whoomp_there_it_is.mp3',
    prod_push: 'push_it.mp3',
    sprint_started: 'the_final_countdown.mp3'
  }

  def perform(event)
    puts event.inspect
    system "omxplayer #{SOUNDS[event.to_sym]}"
  end
end
