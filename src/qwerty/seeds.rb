if Lesson.all.none?
  {
    'Home Row Position' => [
      'jkkjk kjkkj jkjjk kkjkj jjkjk jkjkk kjkjj jkjkj kkjkj jjkjk',
      'dffdf fdffd dfddf ffdfd ddfdf dfdff fdfdd dfdfd ffdfd ddfdf',
      'dkfdj jdfkf kjdkf fkjdk fkdkj fkfdj kjdkf dfkfj kfkdj fjkjd',
      'djk kjd dfk kfdf jdfk jkjdj',
      'l;;l; ;l;;l l;ll; ;;l;l ll;l; l;l;; ;l;ll l;l;l ;;l;l ll;l;',
      'lfk ;fk djlf kflf ;fkj kj;f dj;;f ;f;lf ;lfkf dljdf ;f;lfkf',
      'assas sassa asaas ssasa aasas asass sasaa asasa ssasa aasas',
      'all add; as ask; sad; fas lad dak; dad fad fall; lass dall;',
      'alas dald fall; dad flak; lass sad; fass; all fall lad; ask',
    ],
    'Index Fingers' => [
      'ghhgh hghhg ghggh hhghg gghgh ghghh hghgg ghghg hhghg gghgh',
      'gad has aha; had flag gas; sag ash; gag dash glag half;',
      'gaff; hall hald saga hash; sash gall flag; has dash half',
    ],
    'Middle and Ring Fingers' => %w[],
    'Pinkies' => %w[],
    'Repetition 1' => %w[],
    'Repetition 2' => %w[],
    'Repetition 3' => %w[],
    'Repetition 4' => %w[],
    'Vowels Сryptogram' => %w[],
    'Alphabet Сryptogram' => %w[],
    'Common Combinations' => %w[],
    'Numbers and Punctuation' => %w[],
    'Using Shift Key' => %w[],
    'Numbers and Punctuation 2' => %w[],
    'Sentences' => %w[],
  }
    .each_with_index do |(title, exercises), i|
      lesson = Lesson.create(title: title, position: i)
      exercises.each_with_index do |content, j|
        lesson.add_exercise(content: content, position: j)
      end
    end
end