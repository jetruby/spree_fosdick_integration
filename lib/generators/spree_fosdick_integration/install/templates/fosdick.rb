FOSDICK_CONFIG = YAML.load_file("#{Rails.root}/config/fosdick.yml")[Rails.env]
FOSDICK_STATES_EXCEPTIONS = {
    'U.S. Armed Forces – Americas' => 'AA',
    'U.S. Armed Forces – Europe'   => 'AE',
    'U.S. Armed Forces – Pacific'  => 'AP'
}
