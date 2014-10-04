# Class: fail2ban
#
# This module manages fail2ban service and its main configuration files.
# Particularily, it focuses on SSH and e-mailing user/team when an IP
# has been banned.
#
# Sample Usage: include fail2ban
#
# === Hiera:
#
# <code> $teamEmail </code>
# (Required) E-mail used in template to send alerts to on behalf of a Jail.
#

class fail2ban(
  $teamEmail = hiera('team_email', ''),
){
  package { 'fail2ban':
    ensure => installed,
    before => [ File['/etc/fail2ban/fail2ban.conf'],
                File['/etc/fail2ban/jail.conf'],
                File['/etc/fail2ban/jail.local'],
                File['/etc/fail2ban/action.d/sendmail-whois.conf'],
                File['/etc/fail2ban/filter.d/sshd.conf'],
              ],
  }

  file { '/etc/fail2ban/fail2ban.conf':
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('app_fail2ban/fail2ban.erb'),
  }

  file { '/etc/fail2ban/jail.conf':
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('app_fail2ban/jail.erb'),
  }


  file { '/etc/fail2ban/jail.local':
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('app_fail2ban/jail.local.erb'),
  }

  file { '/etc/fail2ban/action.d/sendmail-whois.conf':
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('app_fail2ban/sendmail-whois.erb'),
  }

  file { '/etc/fail2ban/filter.d/sshd.conf':
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('app_fail2ban/sshd.erb'),
  }

  service { 'fail2ban':
    ensure  => running,
    require => Package['fail2ban'],
  }
}