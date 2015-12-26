module TxtServer

  class Search

    def self.find_docs(dir, tester)
      documents = []
      total = walk_docs(dir, tester) { |recipe| documents << recipe }
      return {
        documents: documents,
        hit: documents.size,
        total: total
      }
    end

    def self.make_doc(filename, content)
      doc = {}
      doc[:filename] = File.basename(filename)
      doc[:name]     = File.basename(filename, File.extname(filename)).gsub(/_/, ' ')
      doc[:content]  = content
      doc
    end

    def self.walk_docs(dir, tester)
      total = 0
      Dir.glob(File.join(dir, '*.txt')) do |f|
        total += 1
        content = IO.read(f)
        if tester.test(content) && block_given?
          yield make_doc(f, content)
        end
      end
      return total
    end

  end

end
