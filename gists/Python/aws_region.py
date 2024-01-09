@dataclass(**DC_ARGS)
class AWSRegion:
    """A simple way to represent a Region."""

    code: str
    flag: str

    @classmethod
    def load_many(cls, *regions) -> tuple[AWSRegion]:
        """Forward the requested Region objects."""
        all_regions = (
            cls(code="us-east-1", flag="🇺🇸"),  # United States
            cls(code="us-east-2", flag="🇺🇸"),  # United States
            cls(code="us-west-1", flag="🇺🇸"),  # United States
            cls(code="us-west-2", flag="🇺🇸"),  # United States
            cls(code="eu-west-1", flag="🇮🇪"),  # Ireland
            cls(code="eu-west-2", flag="🇬🇧"),  # United Kingdom
            cls(code="eu-west-3", flag="🇫🇷"),  # France
            cls(code="eu-central-1", flag="🇩🇪"),  # Germany
            cls(code="ap-northeast-1", flag="🇯🇵"),  # Japan
            cls(code="ap-northeast-2", flag="🇰🇷"),  # South Korea
            cls(code="ap-northeast-3", flag="🇮🇳"),  # India
            cls(code="ap-southeast-1", flag="🇸🇬"),  # Singapore
            cls(code="ap-southeast-2", flag="🇦🇺"),  # Australia
            cls(code="sa-east-1", flag="🇧🇷"),  # Brazil
            cls(code="ca-central-1", flag="🇨🇦"),  # Canada
            cls(code="af-south-1", flag="🇿🇦"),  # South Africa
            cls(code="me-south-1", flag="🇦🇪"),  # United Arab Emirates
            cls(code="eu-north-1", flag="🇸🇪"),  # Sweden
            cls(code="eu-south-1", flag="🇮🇹"),  # Italy
        )

        return tuple(filter(lambda r: r.code in regions, all_regions))
