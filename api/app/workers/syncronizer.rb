# frozen_string_literal: true
# This a job worker to sincronize the database with repository
require_relative '../../app'

# Sync data worker.
#
class SincronizerWorker
  include Sidekiq::Worker

  REPO = 'cristianoliveira/awesome4girls'

  def perform
    markdown = GithubClient.from(REPO, 'master').request('README.md')
    data = MarkdownParser.to_hash(markdown)

    p data

    data.select { |s| s['level'] > 1 }.each do |section|
      if section['level'] == 2
        @section = update_section(section)
      else
        subsection = update_subsection(@section, section)
        section['items'].each { |project| update_project(subsection, project) }
      end
    end
  end

  private

  def update_section(item)
    section = Section.find_by(title: item['text'])

    if section
      section.update(title: item['text'],
                     description: item['description'])
    else
      section = Section.create(title: item['text'],
                               description: item['description'])
    end

    section
  end

  def update_subsection(section, item)
    subsection = section.subsections.find_by(title: item['text'])

    if subsection
      subsection.update(title: item['text'], description: item['description'])
    else
      subsection = section.subsections.create(title: item['text'],
                                              description: item['description'])
    end

    subsection
  end

  def update_project(subsection, item)
    project = subsection.projects.find_by(title: item['link']['text'])

    if project
      project.update(title: item['link']['text'],
                     link: item['link']['href'],
                     description: item['description'])
    else
      subsection.projects.create(title: item['link']['text'],
                                 description: item['description'])
    end
  end
end

# This is an auxiliar way to run this code.
# run it by: `ruby app/workers/syncronizer.rb`
SincronizerWorker.new.perform if __FILE__ == $PROGRAM_NAME
