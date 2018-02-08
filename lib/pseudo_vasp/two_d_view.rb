require_relative './viewer'

# two dimension view of eam_analysis
class TwoDView < Viewer
  def set_data(argv)
    @x_lat = argv[:x_lat]
    @y_lat = argv[:y_lat]
    @cx = argv[:cx]
    @scale = argv[:scale]
    @title = argv[:title] || 'no title'
  end

  def initialize(data)
    @data = data
    @pos = data.inject([]) { |ret, idata| ret << [idata[:x], idata[:y], idata[:z]] }
    @nl = data.inject([]) { |ret, idata| ret << idata[:nl].size }
    @normalized_nl = normalize(@nl, rev: true)
    @ene = data.inject([]) { |ret, idata| ret << idata[:ene] }
    @normalized_ene = normalize(@ene)
    @ratio = data.inject([]) { |ret, idata| ret << idata[:ratio] }
    @normalized_ratio = normalize(@ratio)
    super(@pos)
  end

  def normalize(enes, opts = { rev: false })
    start = 180
    min_e = enes.sort[0]
    max_e = enes.sort[-1]
    printf("min_e = %7.4f [eV]\nmax_e = %7.4f [eV]\n", min_e, max_e)
    #    p max_e=-2.8081
    #coeff = (360 - start) / (max_e - min_e)
    #if opts[:rev]
    #  return enes.inject([]) { |ret, ene| ret << 360 - (ene - min_e) * coeff }
    #else
    #return enes.inject([]) { |ret, ene| ret << (ene - min_e) * coeff + start }
    #end
    diff = max_e - min_e
    if opts[:rev]
      return enes.inject([]) { |ret, ene| ret << 360 - 360 * (ene - min_e) / diff}
    else
      return enes.inject([]) { |ret, ene| ret << 360 - 360 * (ene - min_e) / diff}
    end
  end

  def trans_pos(pos, period, rad = 2.0)
    tmp_pos = [@x_lat * period[0] + pos[0], @y_lat * period[1] + pos[1]]
    [*calc_xy(*tmp_pos), rad]
  end

  def draw_atom_by_val(e_p = 0, opts = { val: :ene })
    ext = case e_p
          when 0 then [0]
          when 1 then [-1, 0, 1]
          end
    ext.each do |ii|
      ext.each do |jj|
        @pos.each_with_index do |pos, i|
          val = case opts[:val]
                when :ene then @normalized_ene[i]
                when :nl then @normalized_nl[i]
                when :ratio then @normalized_ratio[i]
                end
          rgb = hsv_to_rgb(val, 100, 100)
          @context.set_source_rgb(*rgb)
          input = trans_pos(pos, [ii, jj])
          @context.circle(*input)
          pos[2] < 0.1 ? @context.stroke : @context.fill
        end
      end
    end
  end

  def draw_val_by_gnuplot(e_p = 0, opts = { val: :ene })
    ext = case e_p
          when 0 then [0]
          when 1 then [-1, 0, 1]
          end
    cont = "\##{@title}\n"
    ext.each do |_ii|
      ext.each do |_jj|
        @pos.each_with_index do |pos, i|
          val = case opts[:val]
                when :ene then @ene[i]
                when :nl then @nl[i]
                end
          cont << format("%10.5f %10.5f %10.5f\n", pos[0], pos[1], val)
        end
      end
    end
    File.open('data_3d.dat', 'w') { |file| file.print cont }
  end

  # http://c4se.hatenablog.com/entry/2013/08/04/190937 by Sacchan
  # h = 0..360, s = 0..100, v = 0..100
  # return r,g,b=0..255
  def hsv_to_rgb(h, s, v)
    s /= 100.0
    v /= 100.0
    c = v * s
#    x = c * (1 - ((h / 60.0) % 2 - 1).abs)
    x = (h % 60.0) / 60.0
    m = v - c
    #r, g, b = if h < 60 then [c, x, 0]
    #          elsif h < 120 then [x, c, 0]
    #          elsif h < 180 then [0, c, x]
    #          elsif h < 240 then [0, x, c]
    #          elsif h < 300 then [x, 0, c]
    #          else [c, 0, x]
    #          end
    
    r, g, b = if h < 60 then [1, 1 - x / 2, 0]
              elsif h < 120 then [1, (1 - x) / 2, 0]
              elsif h < 180 then [1 - x, x, 0]
              elsif h < 240 then [0 ,1 - x, x]
              elsif h < 300 then [x ,0 ,1]
              else [1 - x ,0 ,1 - x]
              end

    [r, g, b].map { |channel| ((channel + m)) }
  end
end
