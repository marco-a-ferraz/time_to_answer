namespace :dev do

  DEFAULT_PASSWORD = 123456
  DEFAULT_FILES_PATH = File.join(Rails.root, 'lib', 'tmp')

  desc "Configura o ambiente de desenvolvimento"
  task setup: :environment do
    if Rails.env.development?
      show_spinner("Drop...") { %x(rails db:drop) }
      show_spinner("Create...") { %x(rails db:create) }
      show_spinner("Migrate...") { %x(rails db:migrate) }
      show_spinner("Cadastrando user...") { %x(rails dev:add_default_user) }
      show_spinner("Cadastrando admin...") { %x(rails dev:add_default_admin) }

    else
      puts "Você não está em ambiente de desenvolvimento!"
    end
  end

  desc "Adiciona o administrador padrão"
  task add_default_admin: :environment do
    Admin.create!(
      email: 'admin@admin.com',
      password: DEFAULT_PASSWORD,
      password_confirmation: DEFAULT_PASSWORD
    )
  end

  desc "Adiciona o usuário padrão"
  task add_default_user: :environment do
    User.create!(
      email: 'user@user.com',
      password: DEFAULT_PASSWORD,
      password_confirmation: DEFAULT_PASSWORD
    )
  end

  private
    def show_spinner(msg_start, msg_stop = "Done!")
        spinner = TTY::Spinner.new("[:spinner] #{msg_start}")
        spinner.auto_spin          
        yield
        spinner.success("(#{msg_stop})")
    end
end