class Key
  attr_accessor :on, :off, :code, :finger

  def initialize(on, off, code, finger)
    @on, @off, @code, @finger = on, off, code, finger
  end
end

class Keyboard; end
class << Keyboard
  def rows
    [
      [
        %w[`         ~         192 0],
        %w[1         !         49  1],
        %w[2         @         50  1],
        %w[3         #         51  2],
        %w[4         $         52  3],
        %w[5         %         53  4],
        %w[6         ^         54  4],
        %w[7         &         55  5],
        %w[8         *         56  6],
        %w[9         (         57  7],
        %w[0         )         48  8],
        %w[-         _         189 8],
        %w[=         +         187 8],
        %w[delete delete 8   0],
      ],
      [
        %w[tab  tab 9   0],
        %w[q    Q   81  1],
        %w[w    W   87  2],
        %w[e    E   69  3],
        %w[r    R   82  4],
        %w[t    T   84  4],
        %w[y    Y   89  5],
        %w[u    U   85  5],
        %w[i    I   73  6],
        %w[o    O   79  7],
        %w[p    P   80  8],
        %w[\[   {   219 8],
        %w[\]   }   221 8],
        %w[\\   |   220 8],
      ],
      [
        %w[caps    caps    20  0],
        %w[a       A       65  1],
        %w[s       S       83  2],
        %w[d       D       68  3],
        %w[f       F       70  4],
        %w[g       G       71  4],
        %w[h       H       72  5],
        %w[j       J       74  5],
        %w[k       K       75  6],
        %w[l       L       76  7],
        %w[;       :       186 8],
        %w['       "       222 8],
        %w[enter   enter   13  0],
      ],
      [
        %w[shift_l   shift_l   16a    0],
        %w[z         Z         90     1],
        %w[x         X         88     2],
        %w[c         C         67     3],
        %w[v         V         86     4],
        %w[b         B         66     4],
        %w[n         N         78     5],
        %w[m         M         77     5],
        %w[,         <         188    6],
        %w[.         >         190    7],
        %w[/         ?         191    8],
        %w[shift_r   shift_r   16b    0],
      ],
      [
        %w[space space 32 0]
      ],
    ].map do |row|
      row.map { |key| Key.new(*key) }
    end
  end
end