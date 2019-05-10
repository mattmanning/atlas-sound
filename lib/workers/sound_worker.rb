class SoundWorker
  include Sidekiq::Worker

  SOUNDS = {
    issue_done: 'all_i_do_is_win.mp3',
    prod_push: 'push_it.mp3',
    sprint_started: 'rocky.mp3'
  }

  def perform(event)
    puts event.inspect
    system "omxplayer #{SOUNDS[event.to_sym]}"
  end
end
