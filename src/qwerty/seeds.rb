if Lesson.all.none?
  {
    'Home Row' => [
      'jjkjk kkjkj jkjkk kjkjj jjkjj kkjkk jkjkj kjkjk',
      'ffdfd ddfdf fdfdd dfdff ffdff ddfdd fdfdf dfdfd',
      'llklk kklkl lklkk klkll llkll kklkk lklkl klklk',
      'lljlj jjljl ljljj jljll lljll jjljj ljljl jljlj',
      'ssdsd ddsds sdsdd dsdss ssdss ddsdd sdsds dsdsd',
      'ssfsf ffsfs sfsff fsfss ssfss ffsff sfsfs fsfsf',
    ],
    'Index Fingers' => %w[],
    'Pinkies' => %w[],
    'Repetition 1' => %w[],
    'Repetition 2' => %w[],
    'Repetition 3' => %w[],
    'Repetition 4' => %w[],
    'Mostly Vowels' => %w[],
    'Full Alphabet' => %w[],
    'Common Chords' => %w[],
    'Top Row' => %w[],
    'Shift Keys' => %w[],
    'Top Row 2' => %w[],
    'Sentences' => %w[],
  }
    .each_with_index do |(title, exercises), i|
      lesson = Lesson.create(title: title, position: i)
      exercises.each_with_index do |content, j|
        lesson.add_exercise(content: content, position: j)
      end
    end
end