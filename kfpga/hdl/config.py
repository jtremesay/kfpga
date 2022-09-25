from typing import Generator, Tuple


class ConfigByte:
    def __init__(self, name: str, width: int) -> None:
        self.name = name
        self.width = width


class ConfigBitstream:
    def __init__(self):
        self.configs = []

    def add_config(self, config: ConfigByte) -> None:
        try:
            self.get_config(config.name)
        except KeyError:
            pass
        else:
            raise ValueError(
                "Config with the same name already exists {}".format(
                    config.name
                )
            )

        self.configs.append(config)

    def get_config(self, name: str) -> ConfigByte:
        for config in self.configs:
            if config.name == name:
                return config

        raise KeyError("Config not found: {}".format(name))

    @property
    def width(self) -> int:
        return sum(c.width for c in self.configs)

    def enumerate(self) -> Generator[Tuple[int, ConfigByte], None, None]:
        offset = 0
        for config in self.configs:
            yield offset, config
            offset += config.width
