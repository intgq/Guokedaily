module MicropostsHelper
    def time_ago_in_words(post_time)
        if post_time.blank?
          return "错误！"
        end
    
        time = (Time.now - post_time).to_i
    
        case time
        when 0 .. 59
          "刚刚"
        when 60 .. 3599
          "#{time / 60} 分钟前"
        when 3600 .. 3600 * 24 - 1
          "#{time / 60 / 24} 小时前"
        else
          post_time.to_s(:db)
        end
      end
end
