class security {

    file { '/etc/audit/rules.d/audit.rules':
        ensure     => file,
        owner      => 'root',
        group      => 'root',
        mode       => '0600',
        source     => 'puppet:///modules/security/etc/audit/audit.rules',
        notify     => Service[ 'auditd' ] 
    }

    file { '/etc/cron.daily/auditd.cron':
        ensure     => file,
        owner      => 'root',
        group      => 'root',
        mode       => '0755',
        source     => 'puppet:///modules/security/etc/cron.daily/auditd.cron'
    }

    file { '/etc/profile':
        ensure     => file,
        owner      => 'root',
        group      => 'root',
        mode       => '0444',
        source     => 'puppet:///modules/security/etc/profile'
    }

    file { '/etc/csh.cshrc':
        ensure     => file,
        owner      => 'root',
        group      => 'root',
        mode       => '0444',
        source     => 'puppet:///modules/security/etc/csh.cshrc'
    }

    file { '/etc/bashrc':
        ensure     => file,
        owner      => 'root',
        group      => 'root',
        mode       => '0444',
        source     => 'puppet:///modules/security/etc/bashrc'
    }

    file { '/etc/cron.allow':
        ensure     => file,
        owner      => 'root',
        group      => 'root',
        mode       => '0400',
        content    => 'root'
    }

    file { '/etc/at.allow':
        ensure     => file,
        owner      => 'root',
        group      => 'root',
        mode       => '0400',
        content     => 'root'
    }

    file { ['/etc/crontab', '/etc/securetty', '/root/.bash_profile', '/root/.bashrc', '/root.cshrc',
           '/root/.tcshrc', '/var/log/lastlog']:
        ensure     => file,
        owner      => 'root',
        group      => 'root',
        mode       => '0400',
    }

    file { ['/etc/at.deny', '/etc/audit/auditd.conf', '/etc/cron.deny', '/etc/sysctl.conf',
           '/etc/security/console.perms', '/etc/skel/.bashrc', '/root/.bash_logout',
           '/var/log/dmesg', '/var/log/wtmp']:
        ensure     => file,
        owner      => 'root',
        group      => 'root',
        mode       => '0600',
    }

    file { ['/etc/csh.login', '/etc/hosts', '/etc/networks', '/etc/services', '/etc/shells']:
        ensure     => file,
        owner      => 'root',
        group      => 'root',
        mode       => '0444',
    }

    file { ['/etc/login.defs', '/etc/security/access.conf']:
        ensure     => file,
        owner      => 'root',
        group      => 'root',
        mode       => '0640',
    }


    file { ['/etc/cron.d', '/etc/cron.daily', '/etc/cron.hourly', '/etc/cron.monthly', '/etc/cron.weekly']:
        ensure     => directory,
        owner      => 'root',
        group      => 'root',
        mode       => '0750',
    }

    file { '/var/log/audit':
        ensure     => directory,
        owner      => 'root',
        group      => 'root',
        mode       => '0700',
    }

    file { '/etc/security':
        ensure     => directory,
        owner      => 'root',
        group      => 'root',
        mode       => '0755',
    }

    file { '/etc/issue':
        ensure     => file,
        owner      => 'root',
        group      => 'root',
        mode       => '0644',
        source     => 'puppet:///modules/security/etc/issue',
    }

    file { '/etc/issue.net':
        ensure     => 'link',
        target     => '/etc/issue',
    }

    file { '/etc/ssh/ssh_banner':
        ensure     => 'link',
        target     => '/etc/issue',
    }

    service { 'auditd':
        ensure     => 'running',
        enable     => 'true',
    }

    augeas { 'init_nosushell':
        context   => '/files/etc/sysconfig/init/',
        changes   => [
           "set SINGLE /sbin/sulogin",
           "set PROMPT no",
        ],
    }

    augeas { 'auditd_conf':
        context   => '/files/etc/audit/auditd.conf/',
        changes   => [
           "set disk_full_action HALT",
           "set disk_error_action HALT",
           "set flush SYNC",
           "set admin_space_left_action email",
           "set space_left_action email",
        ],
    }

    augeas { 'login_defs':
        context   => '/files/etc/login.defs/',
        changes   => [
           "set PASS_MAX_DAYS 180",
           "set PASS_MIN_DAYS 7",
           "set PASS_WARN_AGE 14",
           "set PASS_MIN_LEN 12",
        ],
    }

    augeas { 'sysctl_secure':
        context   => '/files/etc/sysctl.conf/',
        changes   => [
           "set net.ipv4.conf.default.secure_redirects 0",
           "set net.ipv4.conf.accept.secure_redirects 0",
           "set net.ipv4.ip_forward 0",
           "set net.ipv4.conf.all.rp_filter 1",
           "set net.ipv4.conf.default.send_redirects 0",
           "set net.ipv4.conf.all.send_redirects 0",
           "set net.ipv4.conf.all.accept_redirects 0",
           "set net.ipv4.conf.all.secure_redirects 0",
        ],
    }

    augeas { 'hosts_allow':
        context   => '/files/etc/hosts.allow/',
        changes   => [
           "ins 01 after *[last()]",
           "set 01/process ALL",
           "set 01/client ALL",
        ],
        onlyif => 'match *[ process = "ALL" and client = "ALL" ] size == 0',
    }

    augeas { 'hosts_deny':
        context   => '/files/etc/hosts.deny/',
        changes   => [
           "ins 01 after *[last()]",
           "set 01/process ALL",
           "set 01/client ALL",
        ],
        onlyif => 'match *[ process = "ALL" and client = "ALL" ] size == 0',
    }

    augeas { 'ssh_config':
        context   => '/files/etc/ssh/ssh_config/',
        changes   => [
           "set Host/MACs/1 hmac-sha1",
           "set Host/MACs/2 umac-64@openssh.com",
           "set Host/MACs/3 hmac-ripemd160",
        ],
    }

 augeas { 'securetty_novc':
        context   => '/files/etc/securetty/',
        changes   => [
           "rm *[. =~ glob('vc/*')]",
        ],
    }

}
