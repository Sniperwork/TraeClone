# Copyright (c) 2025 ByteDance Ltd. and/or its affiliates
# SPDX-License-Identifier: MIT

"""Z.AI API client implementation."""

from typing import override

import openai

from trae_agent.utils.config import ModelConfig
from trae_agent.utils.llm_clients.openai_compatible_base import (
    OpenAICompatibleClient,
    ProviderConfig,
)


class ZAIProviderConfig(ProviderConfig):
    """Configuration for Z.AI API provider."""

    @override
    def create_client(
        self, api_key: str, base_url: str | None, api_version: str | None
    ) -> openai.OpenAI:
        """Create the OpenAI client instance for Z.AI."""
        return openai.OpenAI(
            api_key=api_key,
            base_url=base_url or "https://api.z.ai/api/paas/v4",
        )

    @override
    def get_service_name(self) -> str:
        """Get the service name for retry logging."""
        return "Z.AI"

    @override
    def get_provider_name(self) -> str:
        """Get the provider name for trajectory recording."""
        return "zai"

    @override
    def get_extra_headers(self) -> dict[str, str]:
        """Get any extra headers needed for the API call."""
        return {}

    @override
    def supports_tool_calling(self, model_name: str) -> bool:
        """Check if the model supports tool calling."""
        # Z.AI supports tool calling for chat completion models
        return True


class ZAIClient(OpenAICompatibleClient):
    """Client for Z.AI API."""

    def __init__(self, model_config: ModelConfig):
        super().__init__(model_config, ZAIProviderConfig())

    @override
    def supports_tool_calling(self, model_config: ModelConfig) -> bool:
        """Check if tool calling is supported."""
        return self.provider_config.supports_tool_calling(model_config.model)
