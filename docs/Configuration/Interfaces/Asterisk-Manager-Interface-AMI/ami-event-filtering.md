# AMI Event Filtering

## Overview

Event filtering allows AMI users to selectively include or exclude events based on event names, headers, and content. This feature helps reduce bandwidth and processing overhead by limiting events to only those relevant to your application.

There are two filtering methods available:
- **Legacy Event Filtering** - Original regex-based method (maintained for backward compatibility)
- **Advanced Event Filtering** - Recommended method with improved performance and flexibility

## Advanced Event Filtering (Recommended)

Advanced filtering provides efficient event selection using event name hashing and targeted header matching, avoiding the performance overhead of full-payload regex scanning.

### Syntax

```
eventfilter(<match_criteria>) = [<match_expression>]
```

### Match Criteria

You can specify up to one of each criterion in any order, separated by commas:

#### action(include|exclude)
- **Default**: `include`
- Controls whether matching events are included or excluded
- `action(include)` - Include events that match
- `action(exclude)` - Exclude events that match

#### name(<event_name>)
- Matches events with the exact event name specified
- Uses efficient hash-based matching instead of regex
- Example: `name(Newchannel)`, `name(Hangup)`

#### header(<header_name>)
- Only processes events containing the specified header
- Constrains the match expression to search only that header's value
- Example: `header(Channel)`, `header(Uniqueid)`

#### method(regex|exact|starts_with|ends_with|contains|none)
- **Default**: `none`
- Defines how the match expression is applied to event data

| Method | Description |
|--------|-------------|
| `regex` | Match as a regular expression anywhere in the data |
| `exact` | Match the entire data exactly |
| `starts_with` | Match at the beginning of the data |
| `ends_with` | Match at the end of the data |
| `contains` | Match anywhere in the data as a literal string |
| `none` | Ignore match expression (useful for name-only filtering) |

### Filter Processing Order

1. **No filters configured** - All events are reported
2. **Include filters only** - Events matching ANY include filter are reported
3. **Exclude filters only** - Events matching ANY exclude filter are blocked
4. **Both include and exclude** - Include filters are applied first, then exclude filters are applied to the resulting set

### Examples

#### Example 1: Include Only Newchannel Events

```ini
eventfilter(name(Newchannel)) =
```

///  warning | Empty Match Expression
The empty right side (after the =) is intentional - you only care about the event name, not the payload content.
///

#### Example 2: Exclude Local Channels from Newchannel and Hangup Events

```ini
eventfilter(action(include),name(Newchannel)) =
eventfilter(action(include),name(Hangup)) =
eventfilter(action(exclude),header(Channel),method(starts_with)) = Local/
```

This configuration:
1. Includes all Newchannel events
2. Includes all Hangup events
3. Excludes any event with a Channel header starting with "Local/"

#### Example 3: Include Only Specific SIP Channels

```ini
eventfilter(header(Channel),method(regex)) = (PJ)?SIP/(james|jim|john)-
```

Matches events with a Channel header containing PJSIP or SIP channels for specific users.

#### Example 4: Exclude DAHDI Channels from All Events

```ini
eventfilter(action(exclude),header(Channel),method(starts_with)) = DAHDI/
```

Filters out any event where the Channel header starts with "DAHDI/".

#### Example 5: Multiple Event Type Filtering

```ini
eventfilter(action(exclude),name(Newchannel),header(Channel),method(starts_with)) = Local/
eventfilter(action(exclude),name(Hangup),header(Channel),method(starts_with)) = Local/
```

Excludes Newchannel and Hangup events for Local channels, while allowing all other events and all other Newchannel/Hangup events.

## Legacy Event Filtering

///  warning | Deprecated
Legacy filtering is maintained for backward compatibility but is not recommended for new implementations due to performance overhead.
///

### How It Works

Legacy filters use regular expressions applied to the entire event payload. An exclamation point (!) prefix excludes matching events instead of including them.

### Limitations

- **Performance**: Regex matching runs against the full payload of every event
- **Whitespace sensitivity**: Exact spacing and formatting must match
- **Less readable**: Complex filters become difficult to maintain

### Examples

```ini
# Include only Newchannel events
eventfilter=Event: Newchannel

# Include Newchannel events with PJSIP channels
eventfilter = Event: Newchannel.*Channel: PJSIP/

# Exclude events with DAHDI channels
eventfilter=!Channel: DAHDI/
```

## Best Practices

1. **Use Advanced Filtering** - It's significantly more efficient than legacy filtering
2. **Order your criteria logically** - While order doesn't affect Asterisk, using `action, name, header, method` improves readability
3. **Start with event names** - Use `name()` to filter by event type first for best performance
4. **Use appropriate match methods** - Avoid `regex` when `starts_with`, `ends_with`, or `contains` will work
5. **Test your filters** - Verify filters work as expected before deploying to production
6. **Document your filters** - Add comments explaining complex filter logic

## Configuration Location

Event filters are configured in the AMI user configuration file:
- **File**: `/etc/asterisk/manager.conf`
- **Section**: Under each AMI user definition

Example configuration:

```ini
[myamiuser]
secret = mysecret
read = system,call,log,verbose,command,agent,user
write = system,call,log,verbose,command,agent,user
eventfilter(action(include),name(Newchannel)) =
eventfilter(action(include),name(Hangup)) =
eventfilter(action(exclude),header(Channel),method(starts_with)) = Local/
```

## See Also

- [Asterisk Manager Interface (AMI)](/Configuration/Interfaces/Asterisk-Manager-Interface-AMI/)
- [AMI Configuration](/Configuration/Interfaces/Asterisk-Manager-Interface-AMI/AMI-Configuration/)
- [AMI Events](/Configuration/Interfaces/Asterisk-Manager-Interface-AMI/AMI-Events/)