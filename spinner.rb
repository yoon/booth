# http://books.google.com/books?id=bKCuEhzyUgMC&pg=PA279&lpg=PA279&dq=ruby+puts+spinner&source=bl&ots=vSYEoZOfJy&sig=FzD4Ss_GUlfCALIUIQd_GDVbxxI&hl=en&ei=ClJ8SuToGofYNvLwwO8C&sa=X&oi=book_result&ct=result&resnum=2#v=onepage&q=ruby%20puts%20spinner&f=false
class Spinner
  Baton = '\|/-'
  def initialize
    STDOUT.flush
    @child = fork do
      trap('SIGHUP') do
        print " \b"
        STDOUT.flush
        exit!
      end
      rotation = 0
      loop do
        printf "%c\b", Baton[(rotation+=1)&3]
        STDOUT.flush
        sleep 0.1
      end
    end
  end
  def stop
    Process.kill 'SIGHUP', @child
  end
end
# animation = Spinner.new
# sleep 2
# puts "foo"
# sleep 2
# animation.stop
