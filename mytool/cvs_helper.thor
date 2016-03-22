require 'fileutils'
class CvsHelp < Thor
  desc "copy EXTS SRC_DIR DIST_DIR", "copy *.ext1,*.ext2 from SRC_DIR to DIST_DIR¥n EXTS='ext1,ext2'¥nexcludes build dir"
  def copy(exts, src, dist)
    src_dir = File.expand_path("#{src}")
    dist_dir = File.expand_path("#{dist}")
    exts.split(",").each do |ext|
      copy_files_by_ext(ext, src_dir, dist_dir)
    end
  end
  no_tasks do 
    def copy_files_by_ext(ext, src_dir, dist_dir)
      Dir::glob("#{src_dir}/**/*.#{ext}").each do |f|
        next if f.include?("/build/")
        target = f.gsub(src_dir, dist_dir)
        if !File.exist?(target)
          target_dir = File.dirname(target)
          FileUtils.mkdir_p(target_dir) if !File.exist?(target_dir)
          FileUtils.copy(f, target)
        end
      end
    end
  end
end
