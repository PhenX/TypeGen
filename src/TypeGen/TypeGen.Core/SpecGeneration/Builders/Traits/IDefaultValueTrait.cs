namespace TypeGen.Core.SpecGeneration.Builders.Traits;

internal interface IDefaultValueTrait<TSpecBuilder>
{
    /// <summary>
    /// Specifies the default value for the selected member (equivalent of TsDefaultValueAttribute).
    /// </summary>
    /// <param name="defaultValue">The default value.</param>
    /// <returns>The current instance of <typeparamref name="TSpecBuilder"/>.</returns>
    TSpecBuilder DefaultValue(string defaultValue);
}